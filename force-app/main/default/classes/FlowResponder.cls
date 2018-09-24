/**
 * FlowResponder enables the Admin to build basic chat behavior with Autolaunch Flows 
 **/
@RestResource(urlMapping='/flowresponder/*')
global with sharing class FlowResponder {

    /**
     * REST API entry point, e.g /flowresponder/eventsignup/41512342323
     **/
    @HttpPost    
    global static String post(String userResponse) {
        // Decompose the URI for the flow to run and the ctx/state key
        List<String> requestUriParts = RestContext.request.requestURI.split('/');
        String flowName = requestUriParts[2];
        String flowCtx = requestUriParts[3];
        System.debug(requestUriParts);
        return runFlow(flowName, flowCtx, userResponse);
    }

    /**
     * Progress the given auto launch Flow for the given state key
     *  TODO: Error handling to clean up the state in case of Flow failure
     **/
    public static String runFlow(String flowName, String flowCtx, String responseToAsk) {
        // Load or initialize the state for this Flow conversationn
        FlowState__c flowState = null;
        Map<String, Object> flowInputs = null;
        List<FlowState__c> flowStateRecords = [select Key__c, State__c from FlowState__c where Key__c = :flowCtx];
        if(flowStateRecords.size()==1) {
            flowState = flowStateRecords[0];
            flowInputs = (Map<String, Object>) JSON.deserializeUntyped(flowState.State__c);
        } else {
            flowState = new FlowState__c(Key__c = flowCtx);
            flowInputs = init(flowName, flowCtx);
        }
        // Update the response to the last ask?
        String flowAskTarget = (String) flowInputs.get('flow_askTarget');
        if(responseToAsk!=null && flowAskTarget!=null && flowAskTarget.length()>0) {
            flowInputs.put(flowAskTarget, responseToAsk);
        }
        // Reset outputs
        flowInputs.put('flow_ask', null);
        flowInputs.put('flow_askTarget', null);
        flowInputs.put('flow_say', null);
        // Run the flow
        System.debug('Flow Inputs:' + flowInputs);
        Flow.Interview flow = Flow.Interview.createInterview(flowName, flowInputs);
        flow.start();
        Map<String, Object> flowOutputs = new Map<String, Object>();
        for(String outputVar : flowInputs.keySet()) {
            flowOutputs.put(outputVar, flow.getVariableValue(outputVar));
        }
        System.debug('Flow Outputs:' + flowOutputs);
        // Something to ask or just say?
        String ask = (String) flowOutputs.get('flow_ask');
        String say = (String) flowOutputs.get('flow_say');
        // Store the state if we are progressing the conversation
        if(ask!=null && ask.length()>0) {
            flowState.State__c = JSON.serialize(flowOutputs);
            upsert flowState Key__c;
            return ask;
        }
        // Otherwise return the message and clear the state
        if(flowState.Id!=null) {
            delete flowState;
        }
        return say;
    }

    /**
     * Apex Flow API has no Describe facility so ask the Flow itself
     *  TODO: Consider switching to callinng the Flow REST API from here to workaround this
     **/
    public static Map<String, Object> init(String flowName, String flowCtx) {
        Flow.Interview flow = Flow.Interview.createInterview(flowName, new Map<String, Object> { });
        flow.start();
        String outputVarList = (String) flow.getVariableValue('flow_describe');
        List<String> outputVars = outputVarList.split(',');
        Map<String, Object> flowParams = 
            new Map<String, Object> { 
                'flow_describe' => outputVarList,
                'flow_say' => null,
                'flow_ask' => null,
                'flow_askTarget' => null,
                'flow_ctx' => flowCtx };
        for(String outputVar : outputVars) {
            flowParams.put(outputVar, null);
        }
        return flowParams;
    }
}
