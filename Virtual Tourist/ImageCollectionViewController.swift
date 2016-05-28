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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: -Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeBackBarButtonItemTitleTo("OK")
        setupCollectionView()
        
        if let location = location {
            
            setupMapView(location)
            
            if let images = location.images where images.count > 0 {
                collectionViewImages = VTImage.imageForLocationFrom(images)
            } else {
                fetchImagesWithLocation(location)
            }
        }
    }

}

extension ImageCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let images = collectionViewImages {
            return images.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VTCollectionViewCell", forIndexPath: indexPath) as! VTCollectionViewCell
        
        let image = collectionViewImages![indexPath.row]
        cell.imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: image.imageUrl!)!)!)
        
        return cell
    }
}

    //MARK: -Networking Methods
extension ImageCollectionViewController {
    
    func fetchImagesWithLocation(location: Location) {
        FlickrClient.sharedInstance.getImagesFromLocation(location) { (success, pages, images, errorMessage) in
            performUIUpdatesOnMain({ 
                if success {
                    print("Fetch images from Flickr successfully.")
                    self.location!.totalPagesForImages = pages
                    self.collectionViewImages = VTImage.imagesForLocationFrom(images!)
                    self.collectionView.reloadData()
                } else {
                    print("Fetch images from Flickr failed. Error: \(errorMessage)")
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
    
    private func setupCollectionView() {
        let space :CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
}

    //MARK: -Helper methods
extension ImageCollectionViewController {
    func OKButtonClicked() {
        
        navigationController?.popViewControllerAnimated(true)
    }
}
