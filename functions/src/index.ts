import * as functions from "firebase-functions";
// import * as Stripe from "stripe";
const stripe = require('stripe')('sk_test_51KghlqBiO44W4W80gfOIWPSwDKOX9qm8TYm1SKxF7xpierpGG06SvxB9KvVPtPf4hMFPRU6vrfWs9wjsAFw60m7000DNN38WzV');
import * as htmlToText from "html-to-text";
// The Firebase Admin SDK to access Firestore.
import * as admin from "firebase-admin";
admin.initializeApp();
const cambriostore = new admin.firestore.Firestore();

/**
 * I have to do this
 */
export const helloWorld = functions.https.onRequest(
    async (request, response) => {
      functions.logger.info("Hello log!", {structuredData: true});
      //   response.send("woops");
      const writeResult = await admin.firestore().collection("messages")
          .add({original: request.query.text ?? "something"});
      response.send(`result: ${writeResult.id ?? "something"}`);
      //   response.json({result: `Message with ID: ${writeResult.id} added.`});
      updateAllPlainText();
    });

/**
 * I have to do this
 */
function updateAllPlainText() {
  cambriostore.collection("books").get().then(
      (querySnapshot: admin.firestore.QuerySnapshot) => {
        querySnapshot.forEach(
            async (documentSnapshot: admin.firestore.DocumentSnapshot) => {
              let str = "";
              (await documentSnapshot.ref.collection("chapters").get()).forEach(
                  (chapterSnapshot: admin.firestore.DocumentSnapshot) => {
                    str = str.concat(
                        htmlToText.htmlToText(chapterSnapshot.get("text"))
                    );
                  });
              documentSnapshot.ref.set({plain_text: str}, {merge: true});
            }
        );
      }
  );
}

/**
 * I have to do this
 */
export const scheduledFunction = functions.pubsub.schedule("5 2 * * 1")
    .timeZone("America/Denver")
    .onRun(() => {
      functions.logger.info("Scheduled task run!!", {structuredData: true});
      console.log("should do every day, roughly");
      updateAllPlainText();
      return null;
    });

/**
 * Add a new connected account
 */
export const addConnectedAccount = functions.https.onCall(async (data,context) => {
    const email = data.email;

    // Set your secret key. Remember to switch to your live secret key in production.
    // See your keys here: https://dashboard.stripe.com/apikeys

    const profileSnapshot = await cambriostore.collection('user_profiles').doc(data.id).get();
    const idRef = await profileSnapshot.get('connected_account_id');
    var id = '';
    if (idRef===undefined || idRef==null) {
        const account = await stripe.accounts.create({
            type: 'standard',
            email: email,
            business_type: 'individual',
        });
        await cambriostore.collection('user_profiles').doc(data.id)
            .update({'connected_account_id':account.id});
        id = account.id;
    } else {
        id = idRef;
    }

    const accountLink = await stripe.accountLinks.create({
      account: id,
      refresh_url: 'http://localhost:36349/personal_profile',
      return_url: 'http://localhost:36349/personal_profile',
      type: 'account_onboarding',
    });

    return accountLink.url;
});


/**
 * Prepare a subscription for people to subscribe to
 */
export const prepareSubscription = functions.https.onCall(async (data,context) => {

    console.log(data);


    try {
        var product = await stripe.products.retrieve(data.author_firebase_id, {stripeAccount:data.author_account_id});
    } catch (err) {
        // create product
        var product = await stripe.products.create({
          id: data.author_firebase_id,
          name: 'Paid Content',
          description: "Get access to all of this author's Premium Content"
        }, {
            stripeAccount: data.author_account_id,
        });
    }
    console.log(product);
    const price = await stripe.prices.create({
      unit_amount: data.price,
      currency: 'usd',
      recurring: {interval: data.interval},
      product: product.id,
      lookup_key: data.author_firebase_id,
      transfer_lookup_key: true,
    }, {
        stripeAccount: data.author_account_id,
    });
    console.log(price)
    return price;
    // clone the customer token
//     const token = await stripe.tokens.create({
//       customer: data.customer_id,
//     }, {
//       stripeAccount: data.author_account_id,
//     });

    // create actual subscription
//     const subscription = await stripe.subscriptions.create({
//       customer: token,
//       items: [
//         {
//           price: "price_H1y51TElsOZjG",
//         },
//       ],
//       expand: ["latest_invoice.payment_intent"],
//   application_fee_percent: 10,
//     }, {
//       stripeAccount: data.author_account_id,
//     });
});

/**
 * Retreive the price from stripe
 */
export const getPrice = functions.https.onCall(async (data,context) => {
    try {
        console.log(data.author_account_id);
        const result = (await stripe.prices.list({
                                   limit:2,
//                                    lookup_keys:[data.price_lookup_key],
                               }, {
                                   stripeAccount: data.author_account_id,
                               })).data[0];
        console.log(result);
        return result;
    } catch (err) {
        console.log(err);
        return 'something went wrong:' + err;
    }
});