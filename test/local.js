const connect = require("../twilio/connect-to-salesforce");
const auth = require("../authUrl");

const toPhone = process.env.TWILIO_TO_PHONE;
const fromPhone = process.env.TWILIO_FROM_PHONE;

const context = {
  AUTH_TOKEN: "AUTH_TOKEN",
  ACCOUNT_SID: "ACCOUNT_SID",
  DOMAIN_NAME: "DOMAIN_NAME.twil.io",
  getTwilioClient: [Function]
};

const event = {
  ToCountry: "US",
  ToState: "CA",
  SmsMessageSid: "SmsMessageSid",
  NumMedia: "0",
  ToCity: "San Francisco",
  FromZip: "80918",
  SmsSid: "SmsSid",
  FromState: "CO",
  SmsStatus: "received",
  FromCity: "COLORADO SPRINGS",
  Body: "test",
  FromCountry: "US",
  To: toPhone,
  MessagingServiceSid: "MessagingServiceSid",
  ToZip: "",
  NumSegments: "1",
  MessageSid: "MessageSid",
  AccountSid: "AccountSid",
  From: fromPhone
};

const jsonBody = {
  AuthUrl: auth.authUrl
};

event.Body = JSON.stringify(jsonBody);

connect.handler(context, event, output => {});
