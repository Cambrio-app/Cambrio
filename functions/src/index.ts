import * as functions from "firebase-functions";
// import * as Stripe from "stripe";
const stripe = require('stripe')('sk_test_51KghlqBiO44W4W80gfOIWPSwDKOX9qm8TYm1SKxF7xpierpGG06SvxB9KvVPtPf4hMFPRU6vrfWs9wjsAFw60m7000DNN38WzV'); //TODO: put in not test key
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
      tax_behavior: 'inclusive',
      transfer_lookup_key: true,
    }, {
        stripeAccount: data.author_account_id,
    });
    console.log(price)
    return price;
});

/**
 * Retreive the price from stripe, using the lookup key for the price (which is the firebase user id
 * of the author), and the stripe account id of the author
 * (which is the same as the connected_account_id stored in the author's profile once they've set
 * up an account to receive payments on.)
 */
export const getPrice = functions.https.onCall(async (data,context) => {
    try {
        console.log('id: ' + data.author_account_id + ' lookup key: ' + data.price_lookup_key);
        const prices = (await stripe.prices.list({
                                   limit:2,
                                   lookup_keys:[data.price_lookup_key],
                               }, {
                                   stripeAccount: data.author_account_id,
                               }));
        const result = prices.data[0];
        console.log('prices as received from stripe: ' + result);
        return result;
    } catch (err) {
        console.log(err);
        return 'something went wrong:' + err;
    }
});

/**
 * Determine whether the user is already subscribed to this author.
*/
export const isSubscribed = functions.https.onCall(async (data,context) => {
    try {
            console.log('id: ' + data.author_account_id + ' customer id: ' + data.customer_stripe_id);
            const prices = (await stripe.subscriptions.list({
                                       limit:2,
                                       customer:data.customer_stripe_id,
                                   }, {
                                       stripeAccount: data.author_account_id,
                                   }));
            const result = prices.data[0];
            console.log('subscription as received from stripe: ' + result);
            return result;
        } catch (err) {
            console.log(err);
            if ((err.toString()).includes('No such customer')) {
                console.log('there is no such customer');
                return null; // for when there is no customer by that id
            } else {
                return 'something went wrong:' + err;
            }
        }
});


/**
 * subscribe the customer to a subscription
 */
export const subscribe = functions.https.onCall(async (data,context) => {
    console.log('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    try {
        var customerid;
        var session;
        try {
            console.log('pre-token?');
                    // clone the customer *if they exist already*
                    const token = await stripe.tokens.create(
                      {
                      customer: 'cus_M5HhzxoymplEe8'
                      //           customer: data.customer_id,
                      },
                      {stripeAccount: data.author_account_id
                      }
                    );
                    const customer = await stripe.customers.create({
            //           customer: data.customer_id,
                      source: token['id'],
                    }
                      ,{stripeAccount: data.author_account_id,}
                    );
            //         console.log(customer);
                    console.log('customer: ' + customer['id']);
                    customerid = customer['id'];

                    // create actual subscription
                              session = await stripe.checkout.sessions.create({
                                customer: customerid,
                                customer_update: {
                                    address:'auto',
                                },
                                line_items: [
                                  {
                                    price: data.price,
                                    quantity: 1,
                                  },
                                ],
                                mode: 'subscription',
                                success_url: `https://stripe.com/docs/payments/checkout/custom-success-page`,
                                cancel_url: `https://stripe.com/docs/payments/checkout/custom-success-page`,
                                automatic_tax: {enabled: true},
                                subscription_data: {
                                    application_fee_percent: 10,
                                    description: "If the developer hasn't put anything useful in this box, send us the screenshot of this and you can choose to take his job.",
                                },

                              }, {
                                stripeAccount: data.author_account_id,
                              });

        } catch (tokenerror) { // for when it's the customer's first purchase.
            if ((tokenerror.toString()).includes('The customer must have an active payment source attached.')) {
                console.log('customer doesnt have payment method attached');

                // create actual subscription, same as above except you don't bother with trying to give the existing customer.
                          session = await stripe.checkout.sessions.create({
                            line_items: [
                              {
                                price: data.price,
                                quantity: 1,
                              },
                            ],
                            mode: 'subscription',
                            success_url: "http://localhost:41723/order/success?session_id={CHECKOUT_SESSION_ID}",
                            cancel_url: `https://stripe.com/docs/payments/checkout/custom-success-page`,
                            automatic_tax: {enabled: true},
                            subscription_data: {
                                application_fee_percent: 10,
                                description: "If the developer hasn't put anything useful in this box, send us the screenshot of this and you can choose to take his job.",
                            },

                          }, {
                            stripeAccount: data.author_account_id,
                          });




            } else {
                return 'something went wrong:' + tokenerror;
            }
        }




        // doesn't work because there's nowhere for the user to put in their payment data.
//         const subscription = await stripe.subscriptions.create({
//           customer: token,
//           items: [
//             {
//               price: data.price,
//             },
//           ],
//           expand: ["latest_invoice.payment_intent"],
//           application_fee_percent: 10,
//         }, {
//           stripeAccount: data.author_account_id,
//         });

        console.log(session);
        return session; // TODO: somehow save the customer's info on the platform
    } catch (err) {
        console.log(err);
        return 'something went wrong buddy boy: ' + err;
    }
});


