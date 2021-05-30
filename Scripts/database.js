const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors({ origin: true }));
try { admin.initializeApp(functions.config().firebase); } catch (e) { }
const database = admin.database();
app.get('/get_users_data', (req, res) => {
    (async () => {
        try {
            let query = database.ref('users/');
            let response = {};
            await query.once('value', (snapshot) => {
                snapshot.forEach((childSnapshot) => {
                    childKey = childSnapshot.key;
                    childVal = childSnapshot.val();
                    response[childKey] = childVal
                });
            })
            //let sort = sort_object(response)
            return res.status(200).send(response);
        } catch (error) {
            console.log(error);
            return res.status(500).send(error);
        }
    })();
});

exports.app = functions.https.onRequest(app);