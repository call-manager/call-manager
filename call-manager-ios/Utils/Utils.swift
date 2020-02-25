//
//  Utils.swift
//
//  Copyright © 2016-2019 Twilio, Inc. All rights reserved.
//

import Foundation

// Helper to determine if we're running on simulator or device
struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

struct TokenUtils {
    static func fetchToken(url : String)-> String {
        let requestURL = url
        var token = ""
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
            let json = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
            token = json["token"] as! String

        }
        catch let error as NSError {
            print(error)
            
            }
        }
        task.resume()
        sleep(3)
        return token

        
    }
}
