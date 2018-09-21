public with sharing class EventSignupSummaryController {
    @AuraEnabled
    public static EventSignupSummary getSummary() {
        // Default response
        EventSignupSummary summary = new EventSignupSummary();
        summary.Count = 0;
        summary.Names = new List<Contact>();
        // Find an event
        List<Event> events = [select Id from Event where Subject like '%Beer%'];
        if(events.size()>0) {
            // Find contacts registered with the event
            Event beerEvent = events[0];
            List<Id> contactIds = new List<Id>();
            List<EventRelation> signups = 
                [select RelationId from EventRelation 
                    where EventId = :beerEvent.Id order by LastModifiedDate desc];
            for(EventRelation signup : signups) {
                contactIds.add(signup.RelationId);
                if(contactIds.size()>9) { // Just show top ten latest registrations
                    break;
                }
            }
            summary.Count = signups.size() -1; // Do not count the event owner
            summary.Names = new List<Contact>();
            Map<Id, Contact> contactsById = 
                new Map<Id, Contact>(
                    [select LastName from Contact where Id in :contactIds]);
            for(Id contactId : contactIds) {
                summary.Names.add(contactsById.get(contactId));
            }
        }        
        return summary;
    }
}
