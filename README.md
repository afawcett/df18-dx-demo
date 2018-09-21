# Dreamforce 2018 - DX Demo

Cool demo showing various platform features for the Dreamforce 2018 DX demo session.

# Testing via Apex

Run each of these one at a time to simulate receiving the SMS messages.

```
System.debug((String) FlowResponder.runFlow('eventsignup', '41512345678', null));
```
```
System.debug((String) FlowResponder.runFlow('eventsignup', '41512345678', 'Yes'));
```
```
System.debug((String) FlowResponder.runFlow('eventsignup', '41512345678', 'Mark Benioff'));
```
```
System.debug(BeerAction.topBeers(new List<BeerAction.Request> { new BeerAction.Request('5995431') })[0].topBeer);
```

# Testing via CURL

Run each of these one at a time to simulate receiving the SMS messages.

```
curl  https://yourorgdomain/services/apexrest/flowresponder/eventsignup/41512342323 -X POST -d '{}' -H "Content-Type: application/json" -H "Authorization: Bearer yourtokenhere"
Returns "Do you like beer?"

curl  https://yourorgdomain/services/apexrest/flowresponder/eventsignup/41512342323 -X POST -d '{ "userResponse": "Yes"}' -H "Content-Type: application/json" -H "Authorization: Bearer yourtokenhere"
Returns "Please let us know your name"

curl  https://yourorgdomain/services/apexrest/flowresponder/eventsignup/41512342323 -X POST -d '{ "userResponse": "Beer Monster"}' -H "Content-Type: application/json" -H "Authorization: Bearer yourtokenhere"
Returns "See you down the pub!"
```

# Testing via Twilio

First, setup exports:

```
# twilio
export TWILIO_ACCOUNT_SID="<your_sid>"
export TWILIO_AUTH_TOKEN="<your_token>"
export TWILIO_TO_PHONE="<your_to_phone>"
export TWILIO_FROM_PHONE="<your_from_phone>"
```

Then install your Node dependencies:

```
yarn install
```

Run the setup script:

```
./setup.sh
```

This will create your scratch org, push the source, and then create a `authUrl.js` file that's used for testing.

You can run the Twilio Function code locally with `node test/local.js`.

To test against the deployed Twilio code, run `node test/sms.js`. Of course, you have to manually deploy updates to Node code.

# Required Setup Steps

Run the setup script:

```
./setup.sh
```
