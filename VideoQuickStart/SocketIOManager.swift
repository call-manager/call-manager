//
//  SocketIOManager.swift
//  VideoQuickStart
//
//  Created by Duo Chen on 2/27/20.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import Foundation
import SocketIO


class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    var socket = SocketIOClient(socketURL: URL(string: "https://17c3eb5e.ngrok.io")!, config: [.log(false), .forcePolling(true)])
    var temp_word: String!
    
    override init() {
        
        
        
        super.init()
        
        socket.on("test") { dataArray, ack in
            print("raw data:", dataArray)
            if let jsonResult = dataArray[0] as? Dictionary<String, AnyObject> {
                // do whatever with jsonResult
                self.temp_word = jsonResult["temp_word"] as? String
            print("haha: ", self.temp_word)
                
            }
        }
    }
    
    func get_temp_word() -> String {
        return self.temp_word
    }

    func establishConnection() {
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }
}

