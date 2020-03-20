//
//  ContactListTableViewCell.swift
//  AudioSinkExample
//
//  Created by Duo Chen on 3/19/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {


    @IBOutlet weak var contact_img: UIImageView!
    
    @IBOutlet weak var contact_name: UILabel!
    
    @IBOutlet weak var contact_email: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
