({
    init : function(component, event, helper) {
        // Get the empApi component.
        var empApi = component.find("empApi");
        // Get the channel from the input box.
        var channel = '/event/EventSignup__e';
        var replayId = -1;

        // Callback function to be passed in the subscribe call.
        // After an event is received, this callback prints the event
        // payload to the console.
        var callback = function (message) {
            console.log("Received [" + message.channel +
                " : " + message.data.event.replayId + "] payload=" +
                JSON.stringify(message.data.payload));
            component.find('notifLib').showToast({
                "variant": "success",
                "title": "New Event Registration",
                "message": message.data.payload.Message__c
              });                 
        }.bind(this);

        // Error handler function that prints the error to the console.
        var errorHandler = function (message) {
            console.log("Received error ", message);
        }.bind(this);

        // Register error listener and pass in the error handler function.
        empApi.onError(errorHandler);

        var sub;
        // Subscribe to the channel and save the returned subscription object.
        empApi.subscribe(channel, replayId, callback).then(function(value) {
            console.log("Subscribed to channel " + channel);
            sub = value;
            component.set("v.sub", sub);
        });
    }
})