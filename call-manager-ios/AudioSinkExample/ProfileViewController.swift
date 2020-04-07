//
//  ProfileViewController.swift
//  AudioSinkExample
//
//  Created by Zihui Qi on 3/22/20.
//  Changed name by Yuning Liu on 4/01/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var photo1: UIImageView!
	
	@IBOutlet weak var photo2: UIImageView!
	
	
	@IBAction func addPhoto1(_ sender: UIButton) {
		photo1.image = UIImage(named: "User2")
		sender.isHidden = true
	}
	
	@IBAction func addPhoto2(_ sender: UIButton) {
		photo2.image = UIImage(named: "User3")
		sender.isHidden = true
	}
	
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        nameField.delegate = self
//        bioField.delegate = self
//    }
    
//	@IBAction func enterTapped(_ sender: Any) {
//        textView.text = "User Name: \(nameField.text!)\nBio: \(bioField.text!)"
//    }
    
}


//extension ProfileViewController : UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
