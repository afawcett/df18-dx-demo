# Flow Responder Service

FlowResponder enables the Admin to build basic chat behavior with Autolaunch Flows

# Testing via Apex

NOTE: Run each of these one at a time.

```
System.debug((String) FlowResponder.runFlow('eventsignup', '41512345678', null));
```
```
System.debug((String) FlowResponder.runFlow('eventsignup', '41512345678', 'Yes'));
```
```
System.debug((String) FlowResponder.runFlow('eventsignup', '41512345678', 'Beer Monster'));
```
```
System.debug(BeerAction.topBeers(new List<BeerAction.Request> { new BeerAction.Request('5995431') })[0].topBeer);
```

# Testing via CURL

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

Enable `Allow Users to Relate Multiple Contacts to Tasks and Events under Activity Settings` in Setup

Edit the layout for the ``Event`` object and to add the `Name` related list

If you did not run the setup.sh script above run the following command to insert sample data

```
sfdx force:user:permset:assign -n UntappedIntegration
sfdx force:data:tree:import -f ./sampledata/Campaign-Event.json
```
