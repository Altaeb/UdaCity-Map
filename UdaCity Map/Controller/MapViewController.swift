//
//  MapViewController.swift
//  UdaCity Map
//
//  Created by Abdalfattah Altaeb on 4/13/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var locationCoordinate: CLLocationCoordinate2D?
    let delegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        mapView.showAnnotations(mapView.annotations, animated: true)
        loadAnnotations()
    }

    // Refresh - clears and repopulates the studentLocation list in the AppDelegate
    // - Parameter sender: refresh bar button
    @IBAction func refreshData(_ sender: Any) {
        self.delegate.studentLocationList.removeAll()
        NetworkUtil.queryStudentLocations{ (studentLocations, error) in
            guard let error = error else {
                guard let studentLocations = studentLocations else {
                    self.displayAlertMainQueue(MapNetworkError.studenLocations)
                    return
                }
                studentLocations.results.forEach({ (student) in
                    self.delegate.studentLocationList.append(student)
                })
                DispatchQueue.main.async {
                    self.loadAnnotations()
                }
                return
            }
            self.displayAlertMainQueue(error)
        }
    }

    @IBAction func logoff(_ sender: Any) {
        NetworkUtil.logoff { (deleteSession, error) in
            guard let error = error else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            self.displayAlertMainQueue(error)
            return
        }
    }

    // Remove and replace all of the annotations from the student list in the app delegate
    func loadAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        delegate.studentLocationList.forEach { (student) in
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = student.firstName
            annotation.subtitle = student.mediaURL
            mapView.addAnnotation(annotation)
        }
    }
}

extension MapViewController : MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = MapConstant.mapViewReuseId
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        switch pinView {
        case nil:
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        default:
            pinView?.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard control == view.rightCalloutAccessoryView else {return}
        guard let urlString = view.annotation?.subtitle??.lowercased() else {return}
        let app = UIApplication.shared
        guard let url = URL(string: urlString) else {
            return
        }
        app.open(url, options: [:], completionHandler: nil)
    }
}
