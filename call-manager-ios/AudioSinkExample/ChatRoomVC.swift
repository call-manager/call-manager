import UIKit
import AVFoundation
import TwilioVideo

class ChatRoomVC: UIViewController {

    let loggedin_username: String = UserDefaults.standard.string(forKey: "username") ?? "NULL"

    var accessToken = ""

    var contents: [String] = [""]
    
    let tokenUrl = ""
    let recordAudio = true
    
    // Video SDK components
    var room: Room?
    var camera: CameraSource?
    var localAudioTrack: LocalAudioTrack!
    var localVideoTrack: LocalVideoTrack!
    // Audio Sinks
    var audioRecorders = Dictionary<String, ExampleAudioRecorder>()
    var speechRecognizer: ExampleSpeechRecognizer?

    // MARK:- UI Element Outlets and handles
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var remoteViewStack: UIStackView!
    @IBOutlet weak var roomTextField: UITextField! // unused
    @IBOutlet weak var roomLine: UIView!
    @IBOutlet weak var roomLabel: UILabel! // unused
    
    // Speech UI
    weak var speechRecognizerView: UIView!
    weak var dimmingView: UIView!
    weak var speechLabel: UILabel!
    
    var messageTimer: Timer!
    
    let kPreviewPadding = CGFloat(10) //
    let kTextBottomPadding = CGFloat(4) //
    let kMaxRemoteVideos = Int(2) //
    
    deinit {
        // We are done with camera
        if let camera = self.camera {
            camera.stopCapture()
            self.camera = nil
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        var bottomRight = CGPoint(x: view.bounds.width, y: view.bounds.height)
        var layoutWidth = view.bounds.width
        // Ensure the preview fits in the safe area.
        let safeAreaGuide = self.view.safeAreaLayoutGuide
        let layoutFrame = safeAreaGuide.layoutFrame
        bottomRight.x = layoutFrame.origin.x + layoutFrame.width
        bottomRight.y = layoutFrame.origin.y + layoutFrame.height
        layoutWidth = layoutFrame.width

        // Layout the speech label.
        if let speechLabel = self.speechLabel {
            speechLabel.preferredMaxLayoutWidth = layoutWidth - (kPreviewPadding * 2)

            let constrainedSize = CGSize(width: view.bounds.width,
                                         height: view.bounds.height)
            let fittingSize = speechLabel.sizeThatFits(constrainedSize)
            let speechFrame = CGRect(x: 0,
                                     y: bottomRight.y - fittingSize.height - kTextBottomPadding,
                                     width: view.bounds.width,
                                     height: (view.bounds.height - bottomRight.y) + fittingSize.height + kTextBottomPadding)
            speechLabel.frame = speechFrame.integral
        }

        // Layout the preview view.
        if let previewView = self.camera?.previewView {
            let dimensions = previewView.videoDimensions
            var previewBounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 160, height: 160))
            previewBounds = AVMakeRect(aspectRatio: CGSize(width: CGFloat(dimensions.width),
                                                           height: CGFloat(dimensions.height)),
                                       insideRect: previewBounds)

            previewBounds = previewBounds.integral
            previewView.bounds = previewBounds
            previewView.center = CGPoint(x: bottomRight.x - previewBounds.width / 2 - kPreviewPadding,
                                         y: bottomRight.y - previewBounds.height / 2 - kPreviewPadding)

            if let speechLabel = self.speechLabel {
                previewView.center.y = speechLabel.frame.minY - (2.0 * kPreviewPadding) - (previewBounds.height / 2.0);
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Chat room: 441"
        // disconnectButton.isHidden = true
        disconnectButton.setTitleColor(UIColor(white: 0.75, alpha: 1), for: .disabled)
        // roomTextField.autocapitalizationType = .none
        // roomTextField.delegate = self
        
        if (recordAudio == false) {navigationItem.leftBarButtonItem = nil} //
        
        prepareLocalMedia()
        	
        showDefaultDisplay()
        
        
    }//viewDidLoad

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    struct TokenResponse: Decodable {
        var identity: String
        var token: String
    }

    func requestToken() {
        // let tokenURL = "https://your-server-here/token"
        let url = URL(string: "http://142.93.241.20:5000/token/\(loggedin_username)")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            self.accessToken = String(data: data, encoding: .utf8)!
        }
        task.resume()
        sleep(1)
    }

    
    private func showDefaultDisplay() {
        // configure access token, if (acceeToken == ...) {}
        if (accessToken == "") {
            requestToken()
        }
        print("token: ", self.accessToken)
        
        let connectOptions = ConnectOptions(token: accessToken) { (builder) in
           if let audioTrack = self.localAudioTrack {
               builder.audioTracks = [audioTrack]
           }
           if let videoTrack = self.localVideoTrack {
               builder.videoTracks = [videoTrack]
           }
           // Use the preferred codecs
           if let preferredAudioCodec = Settings.shared.audioCodec {
               builder.preferredAudioCodecs = [preferredAudioCodec]
           }
           if let preferredVideoCodec = Settings.shared.videoCodec {
               builder.preferredVideoCodecs = [preferredVideoCodec]
           }
           // Use the preferred encoding parameters
           if let encodingParameters = Settings.shared.getEncodingParameters() {
               builder.encodingParameters = encodingParameters
           }
           // Use the preferred signaling region
           if let signalingRegion = Settings.shared.signalingRegion {
               builder.region = signalingRegion
           }
           // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
           // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
           
            builder.roomName = "441"// self.roomTextField.text
       
        }//connectOptions
       
       // Connect to the Room using the options we provided.

       room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
       
       self.showRoomUI(inRoom: false)
        
       //self.roomLabel.isHidden = true // not used
       //self.roomTextField.isHidden = true // not used
        
       self.dismissKeyboard() //
    }
    

    @IBAction func connect(_ sender: Any) {
        // configure access token, if (acceetoken == ...) {}
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = ConnectOptions(token: accessToken) { (builder) in
            if let audioTrack = self.localAudioTrack {
                builder.audioTracks = [audioTrack]
            }
            if let videoTrack = self.localVideoTrack {
                builder.videoTracks = [videoTrack]
            }
            // Use the preferred codecs
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            if let preferredVideoCodec = Settings.shared.videoCodec {
                builder.preferredVideoCodecs = [preferredVideoCodec]
            }
            // Use the preferred encoding parameters
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            // Use the preferred signaling region
            if let signalingRegion = Settings.shared.signalingRegion {
                builder.region = signalingRegion
            }
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            
            builder.roomName = self.roomTextField.text
            
        }//connectOptions
        
        // Connect to the Room using the options we provided.
 
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        
        self.showRoomUI(inRoom: false)
        //self.dismissKeyboard() //
    }
    
    
    @IBAction func disconnect(_ sender: UIButton) {
        
        if let room = self.room {
            logMessage(messageText: "Disconnecting from \(room.name)")
            room.disconnect()
            sender.isEnabled = false
            // (sender as AnyObject).isEnabled = false
        }
        // performSegue(withIdentifier: "showTranscript", sender: self)
        // performSegue(withIdentifier: "disconnectToContactProfile", sender: self)
    }
    
//    @IBAction func disconnect(_ sender: UIButton) {
//        if let room = self.room {
//            logMessage(messageText: "Disconnecting from \(room.name)")
//            room.disconnect()
//            sender.isEnabled = false
//        }
//
//        // Go back to previous contact profile
//
//        sleep(1)
//        self.showNotification(title: "get transcript", message: "")
//        //performSegue(withIdentifier: "showTranscript", sender: self)
//        // performSegue(withIdentifier: "disconnectToContactProfile", sender: self)
//    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showTranscript") {
            if let destinate_vc = segue.destination as? AfterCallTranscriptVC {
                destinate_vc.contents = contents
                // destinate_vc.contents = ["hello", "Nice"]
            }
        }
    }

    
    // Update our UI based upon if we are in a Room or not
    func showRoomUI(inRoom: Bool) {
        //self.connectButton.isHidden = inRoom
        //self.connectButton.isEnabled = !inRoom
        //self.roomTextField.isHidden = inRoom
        self.roomLine.isHidden = inRoom
        //self.roomLabel.isHidden = inRoom
        self.disconnectButton.isHidden = inRoom
        
        self.disconnectButton.isEnabled = !inRoom
        
        UIApplication.shared.isIdleTimerDisabled = inRoom
        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        self.setNeedsStatusBarAppearanceUpdate()

        self.navigationController?.setNavigationBarHidden(inRoom, animated: true)
    }
    
    func showSpeechRecognitionUI(view: UIView, message: String) {
        // Create a dimmer view for the Participant being recognized.
        let dimmer = UIView(frame: view.bounds)
        dimmer.alpha = 0
        dimmer.backgroundColor = UIColor(white: 1, alpha: 0.26)
        dimmer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(dimmer)
        self.dimmingView = dimmer
        self.speechRecognizerView = view

        // Create a label which will be added to the stack and display recognized speech.
        let messageLabel = UILabel()
        messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        messageLabel.textColor = UIColor.white
        messageLabel.backgroundColor = UIColor(red: 226/255, green: 29/255, blue: 37/255, alpha: 1)
        messageLabel.alpha = 0
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.center

        self.view.addSubview(messageLabel)
        self.speechLabel = messageLabel

        // Force a layout to position the speech label before animations.
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.4, animations: {
            self.view.setNeedsLayout()

            messageLabel.text = message
            dimmer.alpha = 1.0
            messageLabel.alpha = 1.0
            view.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            self.disconnectButton.alpha = 0

            self.view.layoutIfNeeded()
        })
    }
    
    // called in stopRecognizingAudio()
    func hideSpeechRecognitionUI(view: UIView) {
        guard let dimmer = self.dimmingView else {
            return
        }

        self.view.setNeedsLayout()

        UIView.animate(withDuration: 0.4, animations: {
            dimmer.alpha = 0.0
            view.transform = CGAffineTransform.identity
            self.speechLabel?.alpha = 0.0
            self.disconnectButton.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { (complete) in
            if (complete) {
                self.speechLabel?.removeFromSuperview()
                self.speechLabel = nil
                dimmer.removeFromSuperview()
                self.dimmingView = nil
                self.speechRecognizerView = nil
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
            }
        })
    }
    
    func dismissKeyboard() {
//        if (self.roomTextField.isFirstResponder) {
//            self.roomTextField.resignFirstResponder()
//        }
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
        messageLabel.text = messageText

        if (messageLabel.alpha < 1.0) {
            self.messageLabel.isHidden = false
            UIView.animate(withDuration: 0.4, animations: {
                self.messageLabel.alpha = 1.0
            })
        }

        // Hide the message with a delay.
        self.messageTimer?.invalidate()
        let timer = Timer(timeInterval: TimeInterval(6), repeats: false) { (timer) in
            if (self.messageLabel.isHidden == false) {
                UIView.animate(withDuration: 0.6, animations: {
                    self.messageLabel.alpha = 0
                }, completion: { (complete) in
                    if (complete) {
                        self.messageLabel.isHidden = true
                    }
                })
            }
        }

        self.messageTimer = timer
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    // MARK:- Speech Recognition
    func stopRecognizingAudio() {
        if let recognizer = self.speechRecognizer {
            recognizer.stopRecognizing()
            self.speechRecognizer = nil

            if let view = self.speechRecognizerView {
                hideSpeechRecognitionUI(view: view)
            }
        }
    }
    
    @objc func recognizeRemoteAudio(gestureRecognizer: UIGestureRecognizer) {
        guard let remoteView = gestureRecognizer.view else {
            print("Couldn't find a view attached to the tap recognizer. \(gestureRecognizer)")
            return;
        }
        guard let room = self.room else {
            print("We are no longer connected to the Room!")
            return
        }

        // Find the Participant.
        let hashedSid = remoteView.tag
        for remoteParticipant in room.remoteParticipants {
            for videoTrackPublication in remoteParticipant.remoteVideoTracks {
                if (videoTrackPublication.trackSid.hashValue == hashedSid) {
                    if let audioTrack = remoteParticipant.remoteAudioTracks.first?.remoteTrack {
                        recognizeRemoteParticipantAudio(audioTrack: audioTrack,
                                                        sid: remoteParticipant.remoteAudioTracks.first!.trackSid,
                                                        name: remoteParticipant.identity,
                                                        view: remoteView)
                    }
                }
            }
        }
    }//recognizeRemoteAudio()
    
    func recognizeRemoteParticipantAudio(audioTrack: RemoteAudioTrack, sid: String, name: String, view: UIView) {
        if (self.speechRecognizer != nil) {
            stopRecognizingAudio()
        } else {
            showSpeechRecognitionUI(view: view, message: "Listening to Doggo...")

            recognizeAudio(audioTrack: audioTrack, identifier: sid)
        }
    }
    
    @objc func recognizeLocalAudio() {
        if (self.speechRecognizer != nil) {
            stopRecognizingAudio()
        } else if let audioTrack = self.localAudioTrack {
            // Known issue - local audio is not available in a Peer-to-Peer Room unless there are >= 1 RemoteParticipants.
            if let room = self.room,
                room.state == .connected || room.state == .reconnecting {

                if let view = self.camera?.previewView {
                    showSpeechRecognitionUI(view: view,
                                            message: "Listening to \(room.localParticipant?.identity ?? "yourself")...")
                }

                recognizeAudio(audioTrack: audioTrack, identifier: audioTrack.name)
            }
        }
    }
    
    func recognizeAudio(audioTrack: AudioTrack, identifier: String) {
        self.speechRecognizer = ExampleSpeechRecognizer(audioTrack: audioTrack,
                                                        identifier: identifier,
                                                     resultHandler: { (result, error) in
                                                                if let validResult = result {
                                                                    var final = ""
                                                                    let text = validResult.bestTranscription.formattedString
                                                                    
                                                                    print(text)
                                                                    
                                                                    
                                                                    let requestURL = "https://translation.googleapis.com/language/translate/v2?key=AIzaSyAw8vknKlbFIDBexnVMjyCcdDVVjfp_y9E"
                                                                    let token = ""
                                                                    var request = URLRequest(url: URL(string: requestURL)!)
                                                                    request.httpMethod = "POST"
                                                                    let t = try? JSONSerialization.data(withJSONObject: ["q": [text], "target": "de",])
                                                                    request.httpBody = t
                                                                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                                                    let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let _ = data, error == nil else {
                                                                        print("NETWORKING ERROR")
                                                                        return
                                                                    }
                                                                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                                                                        print("HTTP STATUS: \(httpStatus.statusCode)")

                                                                        return
                                                                    }
                                                                    do {
                                                                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? [String: Any]
                                                                        let d = json!["data"] as? [String: Any]
                                                                        let k = d!["translations"] as? [[String: Any]]
                                                                        final = (k![0]["translatedText"] as? String)!
                                                                        print(k as Any)
                                                                        print(final as Any)
                                                                        print(token)
                                                                        self.contents.append(final)                                                                    }
                                                                    catch let error as NSError {
                                                                        print(error)
                                                                        
                                                                        }
                                                                    }
                                                                    task.resume()
                                                                    sleep(1)
                                                                    self.speechLabel?.text = final                                                              } else if let error = error {
                                                                    self.speechLabel?.text = error.localizedDescription
                                                                    self.stopRecognizingAudio()
                                                                }

                                                                UIView.animate(withDuration: 0.1, animations: {
                                                                    self.view.setNeedsLayout()
                                                                    self.view.layoutIfNeeded()
                                                                })
        })
    }
    
    func prepareLocalMedia() {
        // Create an audio track.
        localAudioTrack = LocalAudioTrack()
        if (localAudioTrack == nil) { print("Failed to create audio track!"); return }
        // Create a video track which captures from the front camera.
        guard let frontCamera = CameraSource.captureDevice(position: .front) else {
            print("Front camera is not available, using microphone only.")
            return
        }
        // We will render the camera using CameraPreviewView.
        let cameraSourceOptions = CameraSourceOptions() { (builder) in
            builder.enablePreview = true
        }
        self.camera = CameraSource(options: cameraSourceOptions, delegate: self)
        if let camera = self.camera {
            localVideoTrack = LocalVideoTrack(source: camera)
            print("Video track created.")

            if let preview = camera.previewView {
                let tap = UITapGestureRecognizer(target: self, action: #selector(ChatRoomVC.recognizeLocalAudio))
                preview.addGestureRecognizer(tap)
                view.addSubview(preview);
            }

            camera.startCapture(device: frontCamera) { (captureDevice, videoFormat, error) in
                if let error = error {
                    print("Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    self.camera?.previewView?.removeFromSuperview()
                } else {
                    // Layout the camera preview with dimensions appropriate for our orientation.
                    self.view.setNeedsLayout()
                }
            }
        }
    }//prepareLocalMedia()
    
    
    func setupRemoteVideoView(publication: RemoteVideoTrackPublication) {
        // Create a `VideoView` programmatically, and add to our `UIStackView`
        if let remoteView = VideoView(frame: CGRect.zero, delegate:nil) {
            // We will bet that a hash collision between two unique SIDs is very rare.
            remoteView.tag = publication.trackSid.hashValue

            // `VideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit.
            // scaleAspectFit is the default mode when you create `VideoView` programmatically.
            remoteView.contentMode = .scaleAspectFit;

            // Double tap to change the content mode.
            let recognizerDoubleTap = UITapGestureRecognizer(target: self, action: #selector(ChatRoomVC.changeRemoteVideoAspect))
            recognizerDoubleTap.numberOfTapsRequired = 2
            remoteView.addGestureRecognizer(recognizerDoubleTap)

            // Single tap to recognize remote audio.
            let recognizerTap = UITapGestureRecognizer(target: self, action: #selector(ChatRoomVC.recognizeRemoteAudio))
            recognizerTap.require(toFail: recognizerDoubleTap)
            remoteView.addGestureRecognizer(recognizerTap)

            // Start rendering, and add to our stack.
            publication.remoteTrack?.addRenderer(remoteView)
            self.remoteViewStack.addArrangedSubview(remoteView)
        }
    }//seupRemoteVideoView
    
    func removeRemoteVideoView(publication: RemoteVideoTrackPublication) {
        let viewTag = publication.trackSid.hashValue
        if let remoteView = self.remoteViewStack.viewWithTag(viewTag) {
            // Stop rendering, we don't want to receive any more frames.
            publication.remoteTrack?.removeRenderer(remoteView as! VideoRenderer)
            // Automatically removes us from the UIStackView's arranged subviews.
            remoteView.removeFromSuperview()
        }
    }//removeRemoteVideoView
    
    @objc func changeRemoteVideoAspect(gestureRecognizer: UIGestureRecognizer) {
        guard let remoteView = gestureRecognizer.view else {
            print("Couldn't find a view attached to the tap recognizer. \(gestureRecognizer)")
            return;
        }

        if (remoteView.contentMode == .scaleAspectFit) {
            remoteView.contentMode = .scaleAspectFill
        } else {
            remoteView.contentMode = .scaleAspectFit
        }
    }
}









// MARK:- UITextFieldDelegate
extension ChatRoomVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.connect(textField)
        return true
    }
}

// MARK:- RoomDelegate
extension ChatRoomVC : RoomDelegate {
    func roomDidConnect(room: Room) {
        // Listen to events from existing `RemoteParticipant`s
        for remoteParticipant in room.remoteParticipants {
            remoteParticipant.delegate = (self as RemoteParticipantDelegate)
        }

        // Wait until our LocalAudioTrack is assigned a SID to record it.
        if (recordAudio) {
            if let localParticipant = room.localParticipant {
                localParticipant.delegate = (self as LocalParticipantDelegate)
            }

            if let localAudioPublication = room.localParticipant?.localAudioTracks.first,
               let localAudioTrack = localAudioPublication.localTrack {
                let trackSid = localAudioPublication.trackSid
                self.audioRecorders[trackSid] = ExampleAudioRecorder(audioTrack: localAudioTrack,
                                                                     identifier: trackSid)
            }
        }

        var connectMessage = "Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")."
        connectMessage.append("\nTap a video to recognize speech.")
        if (self.audioRecorders.count > 0) {
            connectMessage.append("\nRecording local audio...")
        }
        logMessage(messageText: connectMessage)
    }

    func roomDidDisconnect(room: Room, error: Error?) {
        let requestURL = "http://167.172.255.230/getchatts/"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let _ = data, error == nil else {
            print("NETWORKING ERROR")
            return
        }
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            print("HTTP STATUS: \(httpStatus.statusCode)")

            return
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? [String: Any]
            print(json as Any)
        }
        catch let error as NSError {
            print(error)
            
            }
        }
        task.resume()
        if let disconnectError = error {
            logMessage(messageText: "Disconnected from \(room.name).\ncode = \((disconnectError as NSError).code) error = \(disconnectError.localizedDescription)")
        } else {
            logMessage(messageText: "Disconnected from \(room.name)")
        }

        for recorder in self.audioRecorders.values {
            recorder.stopRecording()
        }
        self.audioRecorders.removeAll()

        // Stop speech recognition!
        stopRecognizingAudio()

        self.room = nil

        self.showRoomUI(inRoom: false)
    }

    func roomDidFailToConnect(room: Room, error: Error) {
//        logMessage(messageText: "Failed to connect to Room\(roomTextField.text):\n\(error.localizedDescription)")
        self.room = nil

        self.showRoomUI(inRoom: false)
    }

    func roomIsReconnecting(room: Room, error: Error) {
        logMessage(messageText: "Reconnecting to room \(room.name), error = \(String(describing: error))")
    }

    func roomDidReconnect(room: Room) {
        logMessage(messageText: "Reconnected to room \(room.name)")
    }

    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        participant.delegate = self

        logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }

    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
    }
}


// MARK:- RemoteParticipantDelegate
extension ChatRoomVC : RemoteParticipantDelegate {
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.

        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
    }

    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }

    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.

        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }

    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has stopped sharing the audio Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }

    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's video Track. We will start receiving the
        // remote Participant's video frames now.

        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")

        // Start remote rendering, and add a touch handler.
        if (self.remoteViewStack.arrangedSubviews.count < kMaxRemoteVideos) {
            setupRemoteVideoView(publication: publication)
        }
    }

    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.

        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")

        // Stop remote rendering.
        removeRemoteVideoView(publication: publication)
    }

    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.

        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")

        if (self.recordAudio) {
            self.audioRecorders[publication.trackSid] = ExampleAudioRecorder(audioTrack: audioTrack,
                                                                             identifier: publication.trackSid)
        }
    }

    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.

        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")

        if let recorder = self.audioRecorders[publication.trackSid] {
            recorder.stopRecording()
            self.audioRecorders.removeValue(forKey: publication.trackSid)
        }

        if (self.speechRecognizer?.identifier == publication.trackSid) {
            self.speechRecognizer?.stopRecognizing()
            self.speechRecognizer = nil
        }
    }

    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }

    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }

    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }

    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // We will continue to record silence and/or recognize audio while a Track is disabled.
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }

    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }

    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// MARK:- LocalParticipantDelegate
extension ChatRoomVC : LocalParticipantDelegate {
    func localParticipantDidPublishAudioTrack(participant: LocalParticipant, audioTrackPublication: LocalAudioTrackPublication) {
        // We expect to publish our AudioTrack at Room connect time, but handle a late publish just to be sure.
        if (recordAudio) {
            let trackSid = audioTrackPublication.trackSid
            self.audioRecorders[trackSid] = ExampleAudioRecorder(audioTrack: audioTrackPublication.localTrack!,
                                                                 identifier: trackSid)
            logMessage(messageText: "Recording local audio...")
        }
    }
}

// MARK:- CameraSourceDelegate
extension ChatRoomVC : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        logMessage(messageText: "Camera source failed with error: \(error.localizedDescription)")
        source.previewView?.removeFromSuperview()
    }
}
