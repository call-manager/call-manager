//
//  LoginViewController.swift
//  AudioSinkExample
//
//  Created by Duo Chen on 4/6/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBAction func clickLogin(_ sender: Any) {
        let username_text: String = username.text!
        let password_text: String = password.text!
        if ((username_text == "alice" || username_text == "bob") && (password_text == "123")) {
            
            let defaults = UserDefaults.standard
            defaults.set(username_text, forKey: "username")
            
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "loginFailPage", sender: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
