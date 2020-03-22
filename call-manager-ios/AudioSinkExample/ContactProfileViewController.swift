//
//  ContactProfileViewController.swift
//  AudioSinkExample
//
//  Created by Duo Chen on 3/20/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit


class ContactProfileViewController: UIViewController {
    
    // profile data from last viewcontroller(ContactListVC)
    var contact_profile: PeopleProfile?
    
    @IBOutlet weak var contact_temp_name_label: UILabel!
    @IBOutlet weak var contact_temp_email_label: UILabel!
    @IBOutlet weak var contact_temp_img_view: UIImageView!
    
    @IBOutlet weak var callButton: UIButton!
    
    @IBAction func callButtonAction(_ sender: Any) {
    
        print("##########MAKECALL, caller: ", "Mina", ", callee: ", contact_profile!.name)

        
        performSegue(withIdentifier: "callSomeone", sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

