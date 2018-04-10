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

class ShareViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var offerPhotoImageView: UIImageView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var behaviorTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: Variables
    var offerPhoto: UIImage? = UIImage()
    var latitudeAndLongitude: String?
    var locationLink: String?
    var newOffer: Offer?
    // Flags
    var isPhotoObtained: Bool = false
    var isCameraAccessible: Bool = false
    var isLocationAccessible: Bool = false
    var isShared: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uptateShareLabelState()
        
        // Set the behaviorTestField managing to the ShareViewController.
        behaviorTextField.delegate = self
        
        // Set the location manager.
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
        
        // Set it disabled by default to prevent the user from saving before sharing.
        saveButton.isEnabled = false
        
        // Localize the strings.
        shareButton.setTitle(NSLocalizedString("share", comment: "Share"), for: .normal)
        cancelButton.setTitle(NSLocalizedString("cancel", comment: "Cancel"), for: .normal)
        saveButton.setTitle(NSLocalizedString("save", comment: "Save"), for: .normal)
        behaviorTextField.placeholder = NSLocalizedString("what_on_your_mind", comment: "What on your mind?")
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            offerPhotoImageView.image = image
            isPhotoObtained = true
            isCameraAccessible = true
        } else {
            print("Cannot get a picture!")
        }
        uptateShareLabelState()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // MARK: Navigation

    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let behavior = behaviorTextField.text
        let photo = offerPhotoImageView.image
        let location = locationLink ?? ""
        
        // Set the offer to be passed to ViewController after the unwind segue.
        newOffer = Offer(behavior: behavior!, photo: photo, location: location)
        
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationValue: CLLocationCoordinate2D = manager.location?.coordinate {
            latitudeAndLongitude = "\(locationValue.latitude),\(locationValue.longitude)"
            isLocationAccessible = true
            uptateShareLabelState()
        } else {
                print("Cannot get the location!");
                self.isLocationAccessible = false
                uptateShareLabelState()
                return
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        uptateShareLabelState()
    }

    
    //MARK: Actions
    @IBAction func shareButtonIsPressed(_ sender: UIButton) {
        // Set the share items.
        let text = "\(behaviorTextField.text ?? "")\n"
        let image = offerPhotoImageView.image
        
        // Location Link Format is: "https://www.google.com/maps/?q= <lat>,<lon"
        let locationLink = "https://www.google.com/maps/?q=\(latitudeAndLongitude ?? "")"
        
        // Set up the activity view controller.
        let shareItems = [text, image!, locationLink] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // Present the activity view controller.
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {(type,completed,items,error) in self.isShared = completed}
        
        if isShared {
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func takePhotoIsPressed(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("camera", comment: "Camera"), style: .default, handler: { (alert:UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.isCameraAccessible = true
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                self.isCameraAccessible = false
                print("Camera is not accessible!")
            }
            self.uptateShareLabelState()
        }))
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("gallery", comment: "Gallery"), style: .default, handler: { (alert:UIAlertAction!) -> Void in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "Cancel"), style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    

    @IBAction func saveButtonIsPressed(_ sender: UIButton) {
        //performSegue(withIdentifier: "shareSegue", sender: self)
    }
    
    
    //MARK: Private Methods
    private func uptateShareLabelState() {
        // Check that every item is filled.
        if !isPhotoObtained {
            shareLabel.text = NSLocalizedString("capture_offer", comment: "Capture an offer")
            shareButton.isEnabled = false
        } else if behaviorTextField.text == "" {
            shareLabel.text = NSLocalizedString("add_comment", comment: "Add your comment")
            shareButton.isEnabled = false
        } else if !isCameraAccessible {
            shareLabel.text = NSLocalizedString("allow_camera", comment: "Allow access to the camera from settings")
            shareButton.isEnabled = false
        } else if false {//!isLocationAccessible {
            shareLabel.text = NSLocalizedString("allow_location", comment: "Allow access to the location from settings")
            shareButton.isEnabled = false
        } else { // Every item is filled.
            // Enable share button.
            shareButton.isEnabled = true
            // Change the label state
            shareLabel.text = NSLocalizedString("share_to_claim", comment: "Share to claim the offer")
        }
    }
}
