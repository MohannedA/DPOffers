//
//  OfferTableViewCell.swift
//  Offers
//
//  Created by Mohanned on 2018-04-07.
//  Copyright © 2018 Mohanned. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    
    @IBOutlet weak var offerBehaviorLabel: UILabel!
    @IBOutlet weak var offerPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func offerLocationButton(_ sender: UIButton) {
    }
}
