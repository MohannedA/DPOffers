//
//  ShareViewController.swift
//  Offers
//
//  Created by Mohanned on 2018-04-09.
//  Copyright © 2018 Mohanned. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ShareViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var offerPhotoImageView: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var behaviorTextField: UITextField!
    
    //MARK: Variables
    var offerPhoto: UIImage? = UIImage()
    var isPhotoObtained: Bool = false
    var latitudeAndLongitude: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*if !isPhotoObtained {
            shareLabel.text = "Capture Offer!"
            shareButton.isEnabled = false
        }*/
        behaviorTextField.delegate = self
        
        let locationManager = CLLocationManager()
        
        // Ask for authorisation from the user.
        locationManager.requestAlwaysAuthorization()
        
        // Usr in the foreground.
        locationManager.requestWhenInUseAuthorization()
        
        // Set up the location manager.
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        offerPhoto = offerPhotoImageView.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate
            else {
                print("Cannot get the location!");
                return
        }
        latitudeAndLongitude = "\(locationValue.latitude),\(locationValue.longitude)"
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    @IBAction func shareButtonIsPressed(_ sender: UIButton) {
        // Set the share items.
        let text = behaviorTextField.text
        let image = offerPhotoImageView.image
        
        // Location Link Format is: "https://www.google.com/maps/?q= <lat>,<lon"
        let locationLink = "https://www.google.com/maps/?q=\(latitudeAndLongitude ?? "")"
        
        // Set up the activity view controller.
        let shareItems = [text!, image!, locationLink] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // Present the activity view controller.
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    

}
