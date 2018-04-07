//
//  OfferTableViewCell.swift
//  Offers
//
//  Created by Mohanned on 2018-04-07.
//  Copyright © 2018 Mohanned. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var offerPhoto: UIImageView!
    @IBOutlet weak var offerBehavior: UILabel!
    @IBOutlet weak var offerLocationButton_Outlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Actions
    @IBAction func offerLocationButton_Action(_ sender: UIButton) {
        // Set the button (when pressed) to open the location in the default web browser.
        if let url = URL(string: (sender.title(for: .normal))!) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    

}
