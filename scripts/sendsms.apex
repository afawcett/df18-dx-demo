TwilioSendSMS sms = new TwilioSendSMS();

string sid = '';
string token = '';
string toPhone = '+';
string fromPhone = '+';
string body = 'test';

sms.Send(sid, token, toPhone, fromPhone, body);