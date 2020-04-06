//
//  EditProfileViewController.swift
//  AudioSinkExample
//
//  Created by Zihui Qi on 4/6/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit

/*extension UIView {
    @discardableResult
    func applyGradient(colors: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colors: colors, locations: nil)
    }

    @discardableResult
    func applyGradient(colors: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}*/

class EditProfileViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameField.delegate = self
        bioField.delegate = self
        
    }
    
    @IBAction func enterTapped(_ sender: Any) {
        textView.text = "User Name: \(userNameField.text!)\nBio: \(bioField.text!)"
    }
}

extension EditProfileViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
