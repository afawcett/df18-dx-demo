({
    init : function(component, event, helper) {

        // Data table column config
        component.set('v.columns', [ {label: 'Name', fieldName: 'LastName', type: 'text'} ]);
        
        // Get the latest summary from the server
        var action = component.get("c.getSummary");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Update the components summary attribute with the response
                var summary = response.getReturnValue();
                console.log(summary);
                component.set('v.summary', summary);
            }
            else if (state === "INCOMPLETE" || state === "ERROR") {
                console.log(state);
            }
        });
        $A.enqueueAction(action);

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
            // Get the latest summary from the server
            var action = component.get("c.getSummary");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    // Update the components summary attribute with the response
                    var summary = response.getReturnValue();
                    component.set('v.summary', summary);
                }
                else if (state === "INCOMPLETE" || state === "ERROR") {
                    console.log(state);
                }
            });
            $A.enqueueAction(action);
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
