//
//  ViewController.swift
//  Offers
//
//  Created by Mohanned on 2018-04-06.
//  Copyright © 2018 Mohanned. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Variables
    var claimedOffers = [Offer]()
    
    //MARK: Properties
    @IBOutlet weak var claimedOffersTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the table view managing cell selection to ViewController.
        claimedOffersTableView.delegate = self
        
        // Set the table view source to the ViewController.
        claimedOffersTableView.dataSource = self
        
        loadSampleOffers()
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
        
        // Set the title to be formed as the google map format (https://www.google.com/maps/?q= <lat>,<lon>).
        cell.offerLocationButton_Outlet.setTitle("https://www.google.com/maps/?q=" + claimedOffers[indexPath.row].location, for: .normal)
        
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


}

