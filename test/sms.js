const twilioAccountSid = process.env.TWILIO_ACCOUNT_SID;
const twilioAuthToken = process.env.TWILIO_AUTH_TOKEN;
const toPhone = process.env.TWILIO_TO_PHONE;
const fromPhone = process.env.TWILIO_FROM_PHONE;

const auth = require("../authUrl");
const client = require("twilio")(twilioAccountSid, twilioAuthToken);

var jsonBody = {
  AuthUrl: auth.authUrl,
  Message: "hello world"
};

client.messages
  .create({
    from: fromPhone,
    to: toPhone,
    body: JSON.stringify(jsonBody)
  })
  .catch(e => {
    console.error("Got an error:", e.code, e.message);
  })
  .then(messsage => {
    console.log(message.sid);
  });
