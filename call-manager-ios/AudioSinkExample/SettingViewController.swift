//
//  SettingViewController.swift
//  AudioSinkExample
//
//  Created by Zihui Qi on 3/22/20.
//  Changed name by Yuning Liu on 4/01/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
	
	@IBOutlet weak var currName: UILabel!
	
	@IBOutlet weak var newName: UITextField!
	
	@IBAction func changeName(_ sender: UIButton) {
		let temp = newName.text
		currName.text = temp
	}
	
}
