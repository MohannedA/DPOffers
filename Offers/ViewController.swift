//
//  ViewController.swift
//  Offers
//
//  Created by Mohanned on 2018-04-06.
//  Copyright © 2018 Mohanned. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables
    var claimedOffers = [Offer]()
    var obtainedPhoto: UIImage?
    
    //MARK: Properties
    @IBOutlet weak var claimedOffersTableView: UITableView!
    @IBOutlet weak var numberOfClaimedOffersLabel: UILabel!
    @IBOutlet weak var claimedOffersLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the table view managing cell selection to ViewController.
        claimedOffersTableView.delegate = self
        
        // Set the table view source to the ViewController.
        claimedOffersTableView.dataSource = self
        
        
        // Load any saved offers, otherwise load sample data.
        if let savedOffers = loadOffers() {
            claimedOffers += savedOffers
        }
        else {
            // Load the sample data.
            loadSampleOffers()
        }
        
        // Localize the strings.
        numberOfClaimedOffersLabel.text = NSLocalizedString("number_of_claimed_offers", comment: "Number of Claimed Offers")
        claimedOffersLabel.text = NSLocalizedString("claimed_offers", comment: "Claimed Offers")

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return claimedOffers.count // Number of rows.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = claimedOffersTableView.dequeueReusableCell(withIdentifier: "cell") as? OfferTableViewCell else {
            fatalError("The dequeued cell is not an instance of OfferTableViewCell.")
        }
        
        cell.offerPhoto.image = claimedOffers[indexPath.row].photo
        cell.offerBehavior.text = claimedOffers[indexPath.row].behavior
        
        // Set the title to be formed as the google map quary format (https://www.google.com/maps/?q= <lat>,<lon>).
        cell.offerLocationButton_Outlet.setTitle("https://www.google.com/maps/?q=" + claimedOffers[indexPath.row].location!, for: .normal)
        
        return cell
    }
    
    private func loadSampleOffers() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        
        guard let offer1 = Offer(behavior: "very good", photo: photo1, location: "1222222") else {
            fatalError("ERROR")
        }
        
        guard  let offer2 = Offer(behavior: "very nice", photo: photo2, location: "122222222") else {
            fatalError("ERROR")
        }
        
        claimedOffers += [offer1, offer2]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let shareVC = segue.destination as? ShareViewController
        shareVC?.offerPhoto = obtainedPhoto
    }
    
    //MARK: Actions
    @IBAction func unwindToOfferList(sender: UIStoryboardSegue) {
        if let shareViewController = sender.source as? ShareViewController, let offer = shareViewController.newOffer {
            
            // Add a new offer
            let newIndexPath = IndexPath(row: claimedOffers.count, section: 0)
            
            claimedOffers.append(offer)
            claimedOffersTableView.insertRows(at: [newIndexPath], with: .automatic)
            
            // Save the offers locally.
            saveOffers()
        }
    }
    
    //MARK: Private Methods
    
    /*
     To save offers locally.
     */
    private func saveOffers() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(claimedOffers, toFile: Offer.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Offers successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save offers...", log: OSLog.default, type: .error)
        }
    }
    
    /*
     To load the saved offers.
     Return opitional so that it could return nothing (which means nothing is saved).
     */
    private func loadOffers() -> [Offer]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Offer.ArchiveURL.path) as? [Offer]
    }

}

