//
//  ViewController.swift
//  lab04
//
//  Created by Piotr Ziniewicz on 05/11/16.
//  Copyright © 2016 Piotr Ziniewicz. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let myLocationManager = CLLocationManager()

    // buttons
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    // button actions
    @IBAction func startButtonAction(sender: UIButton) {
        
        startButton.enabled = false
        stopButton.enabled = true
        
        myLocationManager.startUpdatingLocation()
    }
    
    @IBAction func clearButtonAction(sender: UIButton) {
        
        mapView.removeAnnotations(mapView.annotations)
    }
    
    @IBAction func stopButtonAction(sender: UIButton) {
        
        startButton.enabled = true
        stopButton.enabled = false
        
        myLocationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.enabled = false
        
        if (CLLocationManager.locationServicesEnabled()) {
            myLocationManager.delegate = self
            myLocationManager.requestWhenInUseAuthorization()
        }
        
        mapView.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation = locations[locations.count-1] as CLLocation
        
        let lastLocationCoordinates = CLLocationCoordinate2DMake(lastLocation.coordinate.latitude,
            lastLocation.coordinate.longitude)
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = lastLocationCoordinates
        mapView.addAnnotation(pointAnnotation)
        
        var spanDelta = 0.0
        if let speed = locations.last?.speed where speed > 0 {
            spanDelta = speed/5000
        }
        
        let locationArea = MKCoordinateRegion(center: lastLocationCoordinates, span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta))
        mapView.setRegion(locationArea, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

