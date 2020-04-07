//
//  ContactProfileViewController.swift
//  AudioSinkExample
//
//  Created by Duo Chen on 3/20/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit


class ContactProfileViewController: UIViewController {
    
    let loggedin_username: String = UserDefaults.standard.string(forKey: "username") ?? "NULL"
    
    // profile data from last viewcontroller(ContactListVC)
    var contact_profile: PeopleProfile?
    
    @IBOutlet weak var contact_temp_name_label: UILabel!
    @IBOutlet weak var contact_temp_email_label: UILabel!
    @IBOutlet weak var contact_temp_img_view: UIImageView!
    
    @IBOutlet weak var callButton: UIButton!
    
    @IBAction func callButtonAction(_ sender: Any) {
        
        let caller_callee = ["caller":loggedin_username, "callee":contact_profile!.name]
        SocketIOManager.socket.emit("call", caller_callee)
        
//        SocketIOManager.socket.on("call_accept") { (state, ack) -> Void in
//            if let data = state[0] as? [String:Bool]  {
//                let tmp = data["state"]
//                // if tmp = true., segue
//                print("###data: ", data)
//                print("###State: ", tmp!)
//                self.performSegue(withIdentifier: "callSomeone", sender: self)
//            }
//        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        callButton.isEnabled = true
        callButton.isHidden = false

        // render data from ContactListVC through segue, segue id: showContactProfile
        contact_temp_name_label.text = " \(contact_profile!.name)!"
        contact_temp_email_label.text = " \(contact_profile!.email)!"
        contact_temp_img_view.image = UIImage(named: contact_profile!.image)
        // set profile image to be round
        contact_temp_img_view.layer.masksToBounds = true
        contact_temp_img_view.layer.cornerRadius = contact_temp_img_view.bounds.width / 2
    }
    
    // unwind segue
    @IBAction func unwindToContactProfile(_ sender: UIStoryboardSegue) {
        
    }

}

