//
//  Offer.swift
//  Offers
//
//  Created by Mohanned on 2018-04-07.
//  Copyright © 2018 Mohanned. All rights reserved.
//

import UIKit
import os.log

class Offer: NSObject, NSCoding {
    
    //MARK: Properties
    var behavior: String
    var photo: UIImage?
    var location: String? // FORMAT: <lat>,<lon>
    
    //MARK: Archiving Paths
    
    // The directory where the app save data.
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // Access the path using the syntax: Offer.ArchiveURL.path.
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("offers")
    
    //MARK: Types
    struct PropertyKey {
        static let behavior = "behavior"
        static let photo = "photo"
        static let location = "location"
    }
    
    //MARK: Initialization
    init?(behavior: String, photo: UIImage?, location: String) {
        // Initialize stored properties.
        self.behavior = behavior
        self.photo = photo
        self.location = location
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(behavior, forKey: PropertyKey.behavior)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(location, forKey: PropertyKey.location)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // If docoading the behavior String fails, all the opreations will fail.
        guard let behavior = aDecoder.decodeObject(forKey: PropertyKey.behavior) as? String else {
            os_log("Unable to decode the behavior for a Offer object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Conditional cast is used since photo is optional.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        // If docoading the behavior String fails, all the opreations will fail.
        guard let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String else {
            os_log("Unable to decode the loaction for a Offer object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(behavior: behavior, photo: photo, location: location)
        
    }
    
}
