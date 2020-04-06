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

        self.AfterCallTableView.rowHeight = 44.0
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translated_contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TranscriptCell") as? AfterCallTableViewCell else {
            return UITableViewCell()
        }
        cell.transcript_label.lineBreakMode=NSLineBreakMode.byWordWrapping
        cell.transcript_label.text = translated_contents[indexPath.row]  // cell.transcript_label.text
        cell.raw_label.lineBreakMode=NSLineBreakMode.byWordWrapping
        cell.raw_label.text = raw_contents[indexPath.row]
        print("translated_content: ", translated_contents[indexPath.row])
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
