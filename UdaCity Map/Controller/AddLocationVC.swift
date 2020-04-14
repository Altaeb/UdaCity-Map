//
//  AddLocationVC.swift
//  UdaCity Map
//
//  Created by Abdalfattah Altaeb on 4/13/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationVC: UIViewController {

    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var coordinate: CLLocationCoordinate2D?
    var linkString = ""
    var mapString = ""
    let delegate = UIApplication.shared.delegate as! AppDelegate

    let textFieldDelegate = TextFieldDelegate()

    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
        configureTextfields(textfields: [locationTextField, linkTextField])
        interfaceConfiguration(spin: false)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func interfaceConfiguration(spin: Bool) {
        switch spin {
        case true:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        case false:
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MapConstant.displayMapSegueId {
            let vc = segue.destination as! AddLocationMapVC
            vc.coordinate = coordinate
            vc.linkString = linkString
            vc.mapString = mapString
        }
    }

    fileprivate func resignKeyboard() {
        interfaceConfiguration(spin: false)
        if locationTextField.isFirstResponder {
            locationTextField.resignFirstResponder()
        } else if linkTextField.isFirstResponder {
            linkTextField.resignFirstResponder()
        }
    }

    // find the geocode via addressString and segue to AddLocationMap view controller
    // - Parameter sender: find location button
    @IBAction func findLocation(_ sender: Any) {
        interfaceConfiguration(spin: true)
        let geocoder = CLGeocoder()
        mapString = locationTextField.text ?? ""
        let locationString = locationTextField.text ?? ""
        geocoder.geocodeAddressString(locationString) { (placemark, error) in
            guard let error = error else {
                self.coordinate = placemark?.first?.location?.coordinate
                self.linkString = self.linkTextField.text ?? ""
                self.interfaceConfiguration(spin: false)
                self.performSegue(withIdentifier: MapConstant.displayMapSegueId, sender: self)
                return
            }
            self.displayAlert(error)
            return
        }
        resignKeyboard()
    }

    func configureTextfields(textfields: [UITextField]) {
        textfields.forEach { (textField) in
            textField.delegate = textFieldDelegate
        }
    }

    //MARK: - Keyboard functions and notification un/subscriptions
    @objc func keyboardWillShow(_ notification: Notification) {
        if linkTextField.isFirstResponder || locationTextField.isFirstResponder {
            view.frame.origin.y = -0.25 * getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
         if linkTextField.isFirstResponder || locationTextField.isFirstResponder {
            view.frame.origin.y = 0.0
        }
    }

    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return CGFloat(keyboardFrame.cgRectValue.height)
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

}
