//
//  AddLocationMapVC.swift
//  UdaCity Map
//
//  Created by Abdalfattah Altaeb on 4/13/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class AddLocationMapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var mapString: String?
    var coordinate:CLLocationCoordinate2D?
    var linkString:String?
    var firstName :String?
    var lastName: String?
    let delegate = UIApplication.shared.delegate

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap(coordinate: coordinate, link: linkString ?? "")
    }

    // Finish -assign values and post location and user name
    //
    // - Parameter sender: finish button
    @IBAction func finish(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let uniqueKey = delegate.currentUserSession?.account.key ?? ""
        let postedLatitude = coordinate?.latitude
        let postedLongitude = coordinate?.longitude
        firstName = delegate.user?.firstName
        lastName = delegate.user?.lastName
        let postDictionary = ["uniqueKey": uniqueKey,
                              "firstName": firstName ?? "",
                              "lastName" : lastName ?? "",
                              "mapString": mapString ?? "",
                              "mediaUrl": linkString ?? "",
                              "latitude": postedLatitude ?? 0.0,
                              "longitude": postedLongitude ?? 0.0] as [String : Any]
        NetworkUtil.addLocation(dictionary: postDictionary) { (postLocation, error) in
            guard let error = error else {
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                guard postLocation != nil else {
                    self.displayAlertMainQueue(MapNetworkError.postLocationFailure)
                    return
                }
                return
            }
            self.displayAlertMainQueue(error)
        }
    }

    // Setup the map with coordinates, camera, coordinate span of the region, and add the annotation.
    // - Parameters:
    //   - coordinate: includes the latitude and longitude as a typealias of double (CLLocationDegrees)
    //  - link: student provided url
    func setupMap(coordinate: CLLocationCoordinate2D?, link: String) {
        guard let coordinate = coordinate else {return}
        let annotation = MKPointAnnotation()
        annotation.subtitle = link
        annotation.coordinate = coordinate
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = coordinate
        self.mapView.setCamera(mapCamera, animated: true)
        self.mapView.setCenter(coordinate, animated: true)
        let latitudeDelta = CLLocationDegrees(exactly: 1.0) ?? 1.0
        let longitudeDelta = CLLocationDegrees(exactly: 1.0) ?? 1.0
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        self.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: coordinateSpan), animated: true)
        self.mapView.addAnnotation(annotation)
    }



}
