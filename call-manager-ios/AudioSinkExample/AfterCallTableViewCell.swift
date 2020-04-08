//
//  AfterCallTableViewCell.swift
//  AudioSinkExample
//
//  Created by Duo Chen on 3/23/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit

class AfterCallTableViewCell: UITableViewCell {
    @IBOutlet weak var transcript_label: UILabel!
    @IBOutlet weak var raw_label: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // raw_label.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        // raw_label.isHidden = false
    }

}
