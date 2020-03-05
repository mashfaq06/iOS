//
//  PeripheralTableViewCell.swift
//  BLEProject_2
//
//  Created by Mohammed Ashfaq on 02/12/2018.
//  Copyright © 2018 Mohammed Ashfaq. All rights reserved.
//

import UIKit

class PeripheralTableViewCell: UITableViewCell
{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var rssiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


