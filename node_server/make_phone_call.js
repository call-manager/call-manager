'use strict';

const dotenv = require('dotenv');
dotenv.config();

//const accountSid = '';
const authToken = '';
const client = require('twilio')(process.env.TWILIO_ACCOUNT_SID, authToken);


client.calls.create({
         url: 'http://demo.twilio.com/docs/classic.mp3',
         to: '+17348829877',
         from: '+17348829877'
       }).then(call => console.log(call.sid));
