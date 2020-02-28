'use strict';

/**
 * Load Twilio configuration from .env config file - the following environment
 * variables should be set:
 * process.env.TWILIO_ACCOUNT_SID
 * process.env.TWILIO_API_SID
 * process.env.TWILIO_API_SECRET
 */
const dotenv = require('dotenv');
dotenv.config();

var express = require('express');
var randomName = require('./randomname');
const bodyParser = require('body-parser');
var http = require('http');
var path = require('path');
const twilio = require('twilio');

// Create Express webapp.
var app = express();
var port = process.env.PORT || 3000;
const server = app.listen(port, function() {
  console.log('Express server running on *:' + port);
});

var AccessToken = require('twilio').jwt.AccessToken;
var VideoGrant = AccessToken.VideoGrant;
const { connect } = require('twilio-video');

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
            if (temp_word.length > 25) {
              temp_word = temp_word.slice(25)
            }
            console.log(temp_word)
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

// Set up the path for the quickstart.
var quickstartPath = path.join(__dirname, '../quickstart/public');
app.use('/quickstart', express.static(quickstartPath));

// Set up the path for the examples page.
var examplesPath = path.join(__dirname, '../examples');
app.use('/examples', express.static(examplesPath));

/**
 * Default to the Quick Start application.
 */
app.get('/', function(request, response) {
  response.redirect('/quickstart');
});

app.post("/", (req, res) => {
  res.set("Content-Type", "text/xml");

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

/**
 * Generate an Access Token for a chat application user - it generates a random
 * username for the client requesting a token, and takes a device ID as a query
 * parameter.
 */
app.get('/token', function(request, response) {
  var identity = request.query.identity || randomName();

  // Create an access token which we will sign and return to the client,
  // containing the grant we just created.
  var token = new AccessToken(
    process.env.TWILIO_ACCOUNT_SID,
    process.env.TWILIO_API_KEY,
    process.env.TWILIO_API_SECRET,
    { ttl: MAX_ALLOWED_SESSION_DURATION }
  );

  // Assign the generated identity to the token.
  token.identity = identity;

  // Grant the access token Twilio Video capabilities.
  var grant = new VideoGrant();
  token.addGrant(grant);

  // Serialize the token to a JWT string and include it in a JSON response.
  response.send({
    identity: identity,
    token: token.toJwt()
  });
});

// Test route for socket events.
app.get('/test', (req, res) => {
  io.emit('test', { 'temp_word': 'World' });
  console.log("io emit!")
  res.send('Hello Socket.io :)');
});

// // Create http server and run it.
// var server = http.createServer(app);
// var port = process.env.PORT || 3000;
// server.listen(port, function() {
//   console.log('Express server running on *:' + port);
// });
