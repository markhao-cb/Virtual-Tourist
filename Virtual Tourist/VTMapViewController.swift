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
    
    enum Mode {
        case Normal
        case Edit
    }
    
    let stack = Utilities.appDelegate.stack
    var mode : Mode = .Normal
    var edittingLabel : UILabel!
    
    
    //MARK: -Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEdittingView()
        
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
            let location = createLocationWith(coordinates)
            addAnnotitionToMapViewWith(location)
        }
    }

    @IBAction func enterEditMode(sender: AnyObject) {
        mode = mode == .Normal ? .Edit : .Normal
        setupViews()
    }
}

    //MARK: -Map View Delegate
extension VTMapViewController : MKMapViewDelegate{
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let annotation = view.annotation as! VTAnnotation
        let location = annotation.location!
        if mode == .Normal {
            let imageCollectionVC = self.storyboard?.instantiateViewControllerWithIdentifier("ImageCollectionViewController") as! ImageCollectionViewController
            imageCollectionVC.location = location
            navigationController?.pushViewController(imageCollectionVC, animated: true)
        } else {
            mapView.removeAnnotation(annotation)
            stack.context.deleteObject(location)
            print("Location deleted: \(location)")
        }
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
    
    func createLocationWith(coordinates: CLLocationCoordinate2D) -> Location {
        let longtitude = Float(coordinates.longitude)
        let latitude = Float(coordinates.latitude)
        let location = Location(longtitude: longtitude, latitude: latitude, context: stack.context)
        print("Location created: \(location)")
        return location
    }
}
    //MARK: -UI Related Methods
extension VTMapViewController {
    
    func setupSavedLocations(locations: [Location]) {
        for location in locations {
            addAnnotitionToMapViewWith(location)
        }
    }
    
    private func addAnnotitionToMapViewWith(location: Location) {
        let annotation = VTAnnotation(location: location)
        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude!), longitude: CLLocationDegrees(location.longtitude!))
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }
    
    private func setupEdittingView() {
        let frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.width, Constants.UIConstants.EdittingLabelHeight)
        edittingLabel = UILabel(frame: frame)
        edittingLabel.backgroundColor = UIColor.redColor()
        edittingLabel.textColor = UIColor.whiteColor()
        edittingLabel.font.fontWithSize(16)
        edittingLabel.text = "Tap Pins to Delete"
        edittingLabel.textAlignment = .Center
        self.view.addSubview(edittingLabel)
    }
    
    private func setupViews() {
        var frame = self.view.frame
        if mode == .Edit {
            frame.origin.y -= Constants.UIConstants.EdittingLabelHeight
            editBtn.title = "Done"
        } else {
            frame.origin.y += Constants.UIConstants.EdittingLabelHeight
            editBtn.title = "Edit"
        }
        UIView.animateWithDuration(0.2) {
            self.view.frame = frame
        }
    }
}


