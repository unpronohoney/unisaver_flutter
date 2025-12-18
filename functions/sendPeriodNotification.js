const admin = require("firebase-admin");
const { getFirestore } = require("firebase-admin/firestore");

admin.initializeApp();

module.exports = async function sendPeriodNotification(periodId) {
    try {
        const db = getFirestore(admin.app(), "notificationbase");
        const docRef = db
            .collection("notifications")
            .doc(`period${periodId}`);
        console.log("REF:", docRef.path);

        const doc = await docRef.get();

        console.log("EXISTS:", doc.exists);

        if (!doc.exists) {
            console.log("Notification doc not found");
            return null;
        }
        const data = doc.data();
        console.log("DATA:", data);

        const languages = ["tr", "en"];

        for (const lang of languages) {
            const messages = data.messages[lang];
            if (!messages || messages.length === 0) continue;

            const randomMessage =
              messages[Math.floor(Math.random() * messages.length)];

            await admin.messaging().send({
              notification: {
                title: data.title[lang],
                body: randomMessage,
              },
              topic: `all_${lang}`,
            });

            console.log(`Sent ${lang} notification`);
          }
    } catch (err) {
        console.error("FATAL ERROR");
        console.error(err);
    }

    return null;
  };
