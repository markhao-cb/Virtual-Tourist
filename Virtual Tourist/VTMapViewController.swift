//
//  VTMapViewController.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/26/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class VTMapViewController: UIViewController {
    
    //MARK: -Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    let stack = Utilities.appDelegate.stack
    
    //MARK: -Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        fetchLocations()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: -IBActions
    @IBAction func addAnnotation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .Began {
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let coordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            mapView.addAnnotation(annotation)
            
            saveLocation(coordinates)
        }
    }

    @IBAction func enterEditMode(sender: AnyObject) {
    }
}

    //MARK: -Map View Delegate
extension VTMapViewController : MKMapViewDelegate{
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        //TODO: Add location model to coredata
        print(views)
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //TODO: Touch inside
    }
}

    //CoreData Methods
extension VTMapViewController {
    func fetchLocations() {
        let fetchRequest = NSFetchRequest(entityName: Constants.CoreDataEntities.Location)
        do {
            let locations = try stack.context.executeFetchRequest(fetchRequest) as! [Location]
            print("Fetch locations successfully. \(locations.count) locations found.")
            setupSavedLocations(locations)
        } catch {
            let error = error as NSError
            print("Fetch failed. Error: \(error.localizedDescription)")
        }
    }
    
    func saveLocation(coordinates: CLLocationCoordinate2D) {
        let longtitude = Float(coordinates.longitude)
        let latitude = Float(coordinates.latitude)
        let location = Location(longtitude: longtitude, latitude: latitude, context: stack.context)
        print("Location created: \(location)")
    }
}
    //MARK: -UI Related Methods
extension VTMapViewController {
    
    func setupSavedLocations(locations: [Location]) {
        for location in locations {
            let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude!), longitude: CLLocationDegrees(location.longtitude!))
            addAnnotitionToMapViewWith(coordinates)
        }
    }
    
    private func addAnnotitionToMapViewWith(coordinates: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }
}

