import * as functions from "firebase-functions";
import * as htmlToText from "html-to-text";
// The Firebase Admin SDK to access Firestore.
import * as admin from "firebase-admin";
admin.initializeApp();

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
  const cambriostore = new admin.firestore.Firestore();
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

