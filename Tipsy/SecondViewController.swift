//
//  SecondViewController.swift
//  Tipsy
//
//  Created by Brian Rabe on 8/16/16.
//  Copyright © 2016 Tipsy. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import GeoFire

class SecondViewController: UIViewController {
    @IBAction func btnPressed(sender: UIButton) {
        let geofireRef = FIRDatabase.database().reference()
        let geoFire = GeoFire(firebaseRef: geofireRef)

        geoFire.getLocationForKey("firebase-hq", withCallback: { (location, error) in
            if (error != nil) {
                print("An error occurred getting the location for \"firebase-hq\": \(error.localizedDescription)")
            } else if (location != nil) {
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = "Memphis"
                annotation.subtitle = "TN"
                self.mapView.addAnnotation(annotation)
                let center = CLLocation(latitude: 35.1495, longitude: -90.0490)
                // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
                var circleQuery = geoFire.queryAtLocation(center, withRadius: 0.6)
                
                // Query location by region
                let span2 = MKCoordinateSpanMake(0.001, 0.001)
                let region2 = MKCoordinateRegionMake(center.coordinate, span2)
                var regionQuery = geoFire.queryWithRegion(region2)
                var queryHandle = regionQuery.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in
                    print("Key '\(key)' entered the search area and is at location '\(location)'")
                })
                print("Location for \"firebase-hq\" is [\(location.coordinate.latitude), \(location.coordinate.longitude)]")
            } else {
                print("GeoFire does not contain a location for \"firebase-hq\"")
            }
        })
           }
    
   let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let geofireRef = FIRDatabase.database().reference()
        let geoFire = GeoFire(firebaseRef: geofireRef)
  
        geoFire.setLocation(CLLocation(latitude: 35.1495, longitude: -90.0490), forKey: "firebase-hq") { (error) in
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension SecondViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
}