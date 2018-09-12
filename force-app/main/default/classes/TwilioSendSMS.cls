public with sharing class TwilioSendSMS {

    public TwilioSendSMS() {
        System.Debug('Constructor');
    }

    public void Send(string sid, string token, string toPhone, string fromPhone, string body) {

        System.Debug('method: Send');
        System.Debug('sid: ' + sid);
        System.Debug('token: ' + token);
        System.Debug('toPhone: ' + toPhone);
        System.Debug('fromPhone: ' + fromPhone);
        System.Debug('body: ' + body);

        String url = 'https://api.twilio.com/2010-04-01/Accounts/' + sid + '/Messages';
        
        System.Debug('url: ' + url);

        String payload = 'From=' + fromPhone + '&To=' + toPhone + '&Body=' + body;
        Blob headerValue = Blob.valueOf(sid + ':' + token);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody(payload);
        req.setHeader('Authorization', authorizationHeader);
        HttpResponse res = h.send(req);
    }
}