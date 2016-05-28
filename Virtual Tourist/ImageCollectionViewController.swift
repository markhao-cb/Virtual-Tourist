//
//  ImageCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/26/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import MapKit

class ImageCollectionViewController: UIViewController {
    
    
    //MARK: -Properties
    var location: Location?
    var collectionViewImages : [VTImage]?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: -Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeBackBarButtonItemTitleTo("OK")
        
        if let location = location {
            
            setupMapView(location)
            
            if let images = location.images {
                collectionViewImages = VTImage.imageForLocationFrom(images)
            } else {
                fetchImagesWithLocation(location)
            }
        }
    }

}

    //MARK: -Networking Methods
extension ImageCollectionViewController {
    
    func fetchImagesWithLocation(location: Location) {
        FlickrClient.sharedInstance.getImagesFromLocation(location) { (success, pages, images, errorMessage) in
            performUIUpdatesOnMain({ 
                if success {
                    self.location!.totalPagesForImages = pages
                    self.collectionViewImages = VTImage.imagesForLocationFrom(images!)
                    self.collectionView.reloadData()
                } else {
                    
                }
            })
            
        }
    }
}



    //MARK: -UI related methods
extension ImageCollectionViewController {
    private func changeBackBarButtonItemTitleTo(title: String) {
        let backButton = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(OKButtonClicked))
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setupMapView(location: Location) {
        let coordinate = CLLocationCoordinate2DMake(Double(location.latitude!), Double(location.longtitude!))
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

    //MARK: -Helper methods
extension ImageCollectionViewController {
    func OKButtonClicked() {
        
        navigationController?.popViewControllerAnimated(true)
    }
}
