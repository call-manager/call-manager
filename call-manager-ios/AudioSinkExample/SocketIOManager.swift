//
//  SocketIOManager.swift
//  VideoQuickStart
//
//  Created by Duo Chen on 3/21/20.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SocketIO
import NetworkExtension

class SocketIOManager: NSObject {
    
    // https://viola-flask-server.herokuapp.com
    
    static let socket = SocketIOClient(socketURL: URL(string: "http://127.0.0.1:5000/")!, config: [.log(true), .forcePolling(true)])
    
    override init() {
        super.init()
    }
    

//    func establishConnection() {
//        socket.connect()
//    }
//
//    func closeConnection() {
//        socket.disconnect()
//    }
    
//    func makeCall(caller: String, callee: String) {
//        print("##########MAKECALL, caller: ", caller, ", callee: ", callee)
//        socket.emit("call", caller, callee)
//    }
    
//    func answerCall(completionHandler: (_ twice: String?) -> Void) {
//        socket.on("answer") { (callerAndCallee, ack) -> Void in
//            completionHandler(callerAndCallee[1] as? String)
//        }
//    }
    
//    func answerCall(identity: String) {
//        socket.on("answer") { (callerAndCallee, ack) -> Void in
//            print("@@@@@@@@@ANSWERCALL, caller and callee: ", callerAndCallee)
//            // if callee == myself, pop up incoming call message
//        }
//        // 1alert("asd")
//    }
    

}



