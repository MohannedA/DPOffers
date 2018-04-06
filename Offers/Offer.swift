//
//  Offer.swift
//  Offers
//
//  Created by Mohanned on 2018-04-07.
//  Copyright © 2018 Mohanned. All rights reserved.
//

import UIKit

class Offer {
    var behavior: String
    var photo: UIImage
    var location: [String]
    
    //MARK: Initialization
    init(behavior: String, photo: UIImage, location: [String]) {
        
        // Initialize stored properties.
        self.behavior = behavior
        self.photo = photo
        self.location = location
        
    }
    
}
