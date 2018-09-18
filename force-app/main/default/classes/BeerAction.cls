/**
 * Simple wrapper around the Untapped API that leverages NamedCredentials
 **/
global with sharing class BeerAction {

    @InvocableMethod
    global static List<Response> topBeers(List<Request> topBeerRequests) {
        // Get default connection details via Custom Metadata Type
        Untapped.Connection untappedConnection = Untapped.getDefaultConnection();
        List<Response> responses = new List<Response>();
        for(Request topBeerRequest : topBeerRequests) {
            HttpRequest req = new HttpRequest();
            // Construct API call and parse out the top beer for the given venue
            req.setEndpoint('callout:untappedapi/v4/venue/info/' +
                topBeerRequest.venueId + 
                '?client_id=' + untappedConnection.ClientId + 
                '&client_secret=' + untappedConnection.ClientSecret);
            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            JSONParser parser = JSON.createParser(res.getBody());
            Untapped untapped = new Untapped(parser);
            if(untapped.response.venue.top_beers!=null && 
               untapped.response.venue.top_beers.count!=null &&
               untapped.response.venue.top_beers.count>0) {
                responses.add(new Response(untapped.response.venue.top_beers.items[0].beer.beer_name));
            }
        }
        return responses;
    }

    global class Request {
        public Request() {} 
        public Request(String venueId) { this.venueId = venueId; }
        @InvocableVariable(required=true)
        public String venueId;
    }

    global class Response {
        public Response() {} 
        public Response(String topBeer) { this.topBeer = topBeer; }
        @InvocableVariable(required=true)
        public String topBeer;
    }
}

