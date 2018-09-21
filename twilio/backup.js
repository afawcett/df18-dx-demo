exports.handler = function(context, event, callback) {
  var querystring = require("querystring");
  var request = require("request");

  var body = event.Body;
  var isJsonMessage = false;

  try {
    jsonBody = JSON.parse(body);
    isJsonMessage = true;
  } catch (e) {}

  var salesforceUrl;
  var clientId;
  var clientSecret;
  var refreshToken;

  if (isJsonMessage) {
    var authUrl = jsonBody.AuthUrl;
    authUrl = authUrl.replace("force://", "");

    var split = authUrl.split(":");
    var split2 = split[2].split("@");

    salesforceUrl = `https://${split2[1]}`;
    clientId = split[0];
    clientSecret = split[1];
    refreshToken = split2[0];

    body = jsonBody.Message;
  } else {
    salesforceUrl = context.SALESFORCE_URL;
    clientId = context.CLIENT_ID;
    clientSecret = context.CLIENT_SECRET;
    refreshToken = context.REFRESH_TOKEN;
  }

  console.log("isJsonMessage", isJsonMessage);
  console.log("authUrl", authUrl);

  var fromPhone = event.From;
  var toPhone = event.To;

  var form = {
    grant_type: "refresh_token",
    client_id: clientId,
    client_secret: clientSecret,
    refresh_token: refreshToken
  };

  var formData = querystring.stringify(form);
  var contentLength = formData.length;

  request(
    {
      headers: {
        "Content-Length": contentLength,
        "Content-Type": "application/x-www-form-urlencoded"
      },
      uri: salesforceUrl + "/services/oauth2/token",
      body: formData,
      method: "POST"
    },
    function(errAuth, resAuth, bodyAuth) {
      console.log("uri", salesforceUrl + "/services/oauth2/token");
      console.log("errAuth", errAuth);
      console.log("bodyAuth", bodyAuth);

      if (resAuth.statusCode == 200) {
        var authResponse = JSON.parse(bodyAuth);
        var accessToken = authResponse.access_token;

        request(
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${accessToken}`
            },
            uri:
              salesforceUrl +
              "/services/apexrest/flowresponder/eventsignup/" +
              fromPhone,
            body: `{ "userResponse": "${body}"}`,
            method: "POST"
          },
          function(err, resFlow, bodyFlow) {
            if (resFlow.statusCode == 200) {
              var flowResponse = JSON.parse(bodyFlow);

              console.log("accessToken", accessToken);
              console.log("flowResponse", flowResponse);

              var client;

              try {
                client = context.getTwilioClient();
              } catch (e) {
                const twilioAccountSid = context.TWILIO_ACCOUNT_SID;
                const twilioAuthToken = context.TWILIO_AUTH_TOKEN;

                client = require("twilio")(twilioAccountSid, twilioAuthToken);
              }

              console.log("Sending response");

              client.messages
                .create({
                  from: toPhone,
                  to: fromPhone,
                  body: `${flowResponse}`
                })
                .catch(e => {
                  console.error("Got an error:", e.code, e.message);
                })
                .then(message => {
                  console.log("message.side", message.sid);
                })
                .done(() => {
                  finishSuccess();
                });
            } else {
              finishWithError("Error Calling Flow:" + body);
            }
          }
        );
      } else {
        finishWithError("Error Getting Token:" + body);
      }
    }
  );

  function finishSuccess(body) {
    callback();
  }
  function finishWithError(body) {
    callback(body);
  }
};
