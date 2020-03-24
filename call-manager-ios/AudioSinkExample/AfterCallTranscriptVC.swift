//
//  AfterCallTranscriptVC.swift
//  AudioSinkExample
//
//  Created by Duo Chen on 3/23/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit

class AfterCallTranscriptVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var contents: [String] = []
    
    @IBOutlet weak var AfterCallTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        // Do any additional setup after loading the view.
		let backToContactsButton = UIBarButtonItem(
            title: "Back To Contacts",
            style: .plain,
            target: self,
			action: #selector(backToContacts)
        )
        navigationItem.leftBarButtonItem = backToContactsButton
    }
	
	
	@objc func backToContacts() {
		self.performSegue(withIdentifier: "backToContacts", sender: self)
	}
    
    

     // Table (Contact List)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return people_profile_lists.count
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TranscriptCell") as? AfterCallTableViewCell else {
            return UITableViewCell()
        }
        cell.transcriptCell.text = contents[indexPath.row]
        print("content: ", contents[indexPath.row])
        return cell
    }
    
    // execute on click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
	
//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(animated)
//        let backToContactsButton = UIBarButtonItem(
//            title: "Back To Contacts",
//            style: .plain,
//            target: self,
//            action: "backToContacts"
//        )
//        navigationItem.leftBarButtonItem = backToContactsButton
//	}
	
	
	
	
	
	
	
        
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
