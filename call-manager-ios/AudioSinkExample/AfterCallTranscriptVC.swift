//
//  AfterCallTranscriptVC.swift
//  AudioSinkExample
//
//  Created by Duo Chen on 3/23/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit

class AfterCallTranscriptVC: UIViewController {

    var contents: [String] = ["transcript_test_0", "transcript_test_2"]
    
    @IBOutlet weak var AfterCallTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

     // Table (Contact List)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return people_profile_lists.count
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AfterCallTableViewCell") as? AfterCallTableViewCell else {
            return UITableViewCell()
        }
        cell.transcriptText.text = contents[indexPath.row]
        
        return cell
    }
    
    // execute on click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    // convey data between different vcs through segue, reference: https://learnappmaking.com/pass-data-between-view-controllers-swift-how-to/#forward-segues
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showContactProfile" {
//            // let destinate_vc = segue.destination as? ContactProfileViewController // ViewController
//            // destinate_vc?.contact_temp_name = contact_temp_name
//            // destinate_vc.contact_profile = people_profile_lists[]
//            if let destinate_vc = segue.destination as? ContactProfileViewController {
//                destinate_vc.contact_profile = people_profile_lists[(contactListTable.indexPathForSelectedRow?.row)!]
//            }
//        }
//    }

}
