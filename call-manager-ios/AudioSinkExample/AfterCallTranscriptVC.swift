//
//  AfterCallTranscriptVC.swift
//  AudioSinkExample
//
//  Created by Duo Chen on 3/23/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit


class AfterCallTranscriptVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var static_transcript_title_label: UILabel!
    
    @IBOutlet weak var AfterCallTableView: UITableView!
    
    var translated_contents: [String] = []
    var raw_contents: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.AfterCallTableView.rowHeight = 50.0
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return raw_contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TranscriptCell") as? AfterCallTableViewCell else {
            return UITableViewCell()
        }
        cell.transcript_label.lineBreakMode=NSLineBreakMode.byWordWrapping
        cell.transcript_label.text = translated_contents[indexPath.row] // translated_contents[indexPath.row]
        // cell.transcript_label.isHidden = true
        cell.raw_label.lineBreakMode=NSLineBreakMode.byWordWrapping
        cell.raw_label.text = raw_contents[indexPath.row]
        //print("translated_content: ", translated_contents[indexPath.row])
        
        return cell
    }
    
    

    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        current_index = indexPath.row
//
//        let requestURL = "https://translation.googleapis.com/language/translate/v2?key=AIzaSyAw8vknKlbFIDBexnVMjyCcdDVVjfp_y9E"
//        let text = raw_contents[indexPath.row]
//        // let token = ""
//        var request = URLRequest(url: URL(string: requestURL)!)
//        request.httpMethod = "POST"
//        let t = try? JSONSerialization.data(withJSONObject: ["q": [text], "target": "zh-CN",])
//        request.httpBody = t
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let _ = data, error == nil else {
//                print("NETWORKING ERROR")
//                return
//            }
//        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//            print("HTTP STATUS: \(httpStatus.statusCode)")
//            return
//        }
//        do {
//            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? [String: Any]
//            let d = json!["data"] as? [String: Any]
//            let k = d!["translations"] as? [[String: Any]]
//            let final = (k![0]["translatedText"] as? String)!
//            print(k as Any) // [["translatedText": dank, "detectedSourceLanguage": en]]
//            print("Final: ",final as Any) // ich dank dir
//            cell.transcript_label.text = final
//        }
//        catch let error as NSError {
//            print(error)
//            }
//        }
//        task.resume()
//
//    }



}
