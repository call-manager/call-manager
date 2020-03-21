'use strict';

const dotenv = require('dotenv');
dotenv.config();
//require('dotenv').load()

var express = require('express');
var randomName = require('./randomname');
const bodyParser = require('body-parser');
var http = require('http');
var path = require('path');
var twilio = require('twilio');

var accountSid = ''; // 
var authToken = '' // get from console, not insanely long token

// var client_caller = new twilio(accountSid, authToken);
// console.log("client_caller: ", client_caller)

// Create Express webapp.
var app = express();
var port = process.env.PORT || 3000;
const server = app.listen(port, function() {
  console.log('Express server running on *:' + port);
});

const AccessToken = require('twilio').jwt.AccessToken;
const VideoGrant = AccessToken.VideoGrant;

const { connect, createLocalTracks } = require('twilio-video');

const WebSocket = require("ws");
const wss = new WebSocket.Server({ server });

// Max. period that a Participant is allowed to be in a Room (currently 14400 seconds or 4 hours)
const MAX_ALLOWED_SESSION_DURATION = 14400;

//Include Google Speech to Text
const speech = require("@google-cloud/speech");
const client = new speech.SpeechClient();

// Create socket io instance
const io = require('socket.io')(server)
app.use(express.static('static'));
app.use(bodyParser.urlencoded({  extended: false }));

//Configure Transcription Request
const request = {
  config: {
    encoding: "MULAW",
    sampleRateHertz: 8000,
    languageCode: "en-GB"
  },
  interimResults: true
};

var quickstartPath = path.join(__dirname, '../quickstart/public');
app.use('/quickstart', express.static(quickstartPath));

app.get("/", (req, res) => {
  //console.log("received!")
  //res.send("Welcome to Call Manager!")
  res.redirect('/quickstart');
})

app.get("/token", (req, res) => {
  //console.log(process.env.TWILIO_ACCOUNT_SID)
  const token = new AccessToken(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_API_KEY_SID, process.env.TWILIO_API_KEY_SECRET)
  const identity = req.query.identity || randomName();
  //console.log("token: ", token.toJwt());
  token.identity = identity
  const videoGrant = new VideoGrant();
  token.addGrant(videoGrant);
  res.send({
    identity:identity,
    token:token.toJwt()
  })
})


// // Test route for socket events.
// app.get('/test', (req, res) => {
//   io.emit('test', { 'temp_word': 'World' });
//   console.log("io emit!")
//   res.send('Hello Socket.io :)');
// });


// Set socket.io listeners
io.on('connection', (socket) => {
  console.log('a user connected');
  socket.on('disconnect', () => {
    console.log('user disconnected');
  })
})

// Handle Web Socket Connection
wss.on("connection", function connection(ws) {
console.log("New Connection Initiated");

  let recognizeStream = null;
  let temp_word = "";

  ws.on("message", function incoming(message) {
    const msg = JSON.parse(message);
    switch (msg.event) {
      case "connected":
      
        console.log(`A new call has connected.`);

        // Create Stream to the Google Speech to Text API
        recognizeStream = client
          .streamingRecognize(request)
          .on("error", console.error)
          .on("data", data => {
            temp_word = data.results[0].alternatives[0].transcript;
            // send to ios client
            // if (temp_word.length > 25) {
            //   temp_word = temp_word.slice(25)
            // }
            console.log(temp_word.length,temp_word)
            io.emit('test', {'temp_word':temp_word})
            //temp_word = data.results[0].alternatives[0].transcript

            wss.clients.forEach(client => {
             if (client.readyState === WebSocket.OPEN) {
               client.send(
                 JSON.stringify({
                 event: "interim-transcription",
                 text: temp_word
               })
             );//if
            }//wss

          });
        });
        break;
      case "start":
        console.log(`Starting Media Stream ${msg.streamSid}`);
        break;
      case "media":
        // Write Media Packets to the recognize stream
        recognizeStream.write(msg.media.payload);
        break;
      case "stop":
        console.log(`Call Has Ended`);
        // Promise.resolve()
        //   .then(() => recognizeStream.destroy())
        //   .catch(console.log)
        recognizeStream.destroy();
        break;
    }
  });
});


// <Start>
//   <Stream url="wss://${req.headers.host}/"/>
// </Start>
// <Say>Thank you for using call manager! I will stream the next 300 seconds of audio through your websocket</Say>
// <Pause length="300" />

// Q: Can server realize when 2 people(mobile) connect
app.post("/", (req, res) => { // can specify identity here
  res.set("Content-Type", "text/xml");
  // log message for testing
  //console.log("req.hearders.host: ", req.hearders.host)
  console.log("call received")
  res.send(`
    <Response>
      <Start>
        <Stream url="wss://${req.headers.host}/"/>
      </Start>
      <Say>Thank you for using call manager! I will stream the next 300 seconds of audio through your websocket</Say>
      <Pause length="300" />
    </Response>
  `);
});

// /**
//  * Generate an Access Token for a chat application user - it generates a random
//  * username for the client requesting a token, and takes a device ID as a query
//  * parameter.
//  */
// app.get('/token', function(request, response) {
//   var identity = request.query.identity || randomName();

//   // Create an access token which we will sign and return to the client,
//   // containing the grant we just created.
//   console.log(process.env.TWILIO_API_SID)

//   var token = new AccessToken(
//     process.env.TWILIO_ACCOUNT_SID,
//     process.env.TWILIO_API_KEY,
//     process.env.TWILIO_API_SECRET,
//     { ttl: MAX_ALLOWED_SESSION_DURATION }
//   );

//   // Assign the generated identity to the token.
//   token.identity = identity;

//   // Grant the access token Twilio Video capabilities.
//   var grant = new VideoGrant({
//     room: '441'
//   });
//   token.addGrant(grant);

//   // Serialize the token to a JWT string and include it in a JSON response.
//   response.send({
//     identity: identity,
//     token: token.toJwt()
//   });

//   console.log(token.toJwt());

// });

// gcloud auth activate-service-account \
//    holacorona@holacorona.iam.gserviceaccount.com \
//           --key-file=/Users/duochen/Desktop/Winter20/capstone/test-final/call-manager/node_server/holacorona-eef8269a17ee.json --project=holacorona



// Test route for socket events.
app.get('/test', (req, res) => {
  io.emit('test', { 'temp_word': 'Skeletal Product has too much feaetures' });
  console.log("io emit!")
  res.send('Hello Socket.io :)');
});

// Test route for ios post request
// app.post('/call', (req, res) => {
//   console.log("client works! ", client_caller)
//   client_caller.calls
//         .create({
//            url: 'http://demo.twilio.com/docs/voice.xml',
//            to: '+17348829877',
//            from: '+15089162963'
//          })
//         .then(call => console.log(call.sid));

//   res.send('Hello I received the post request from mobile client!')
// })

// // // Create http server and run it.
// // var server = http.createServer(app);
// // var port = process.env.PORT || 3000;
// // server.listen(port, function() {
// //   console.log('Express server running on *:' + port);
// // });
