//
//  ImageCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/26/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher
import NVActivityIndicatorView

class ImageCollectionViewController: UIViewController {
    
    
    //MARK: -Properties
    var location: Location?
    var collectionViewImages : [VTImage]?
    var CollectionFetchedOrEditted : Bool = false
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newCollectionBtn: UIBarButtonItem!
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var maskView: UIView!
    
    //MARK: -Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeBackBarButtonItemTitleTo("OK")
        setupCollectionView()
        maskView.alpha = 0
        noImageLabel.hidden = true
        
        if let location = location {
            
            setupMapView(location)
            
            if let images = location.images where images.count > 0 {
                collectionViewImages = VTImage.imageForLocationFrom(images)
            } else {
                fetchImagesWithLocation(location, page: getRandomPageNumber())
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveLocationImages()
    }

}

//MARK: -Collection View Delegate && DataSource Methods
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
        
        if let data = image.imageData {
            cell.imageView.image = UIImage(data: data)
            cell.imageView.alpha = 1.0
            
        } else {
            
            let imageUrl = NSURL(string: image.imageUrl!)
            //Add ActivityIndicator Cell
            let activityIndicatorView = NVActivityIndicatorView.init(frame: CGRectMake(cell.frame.width / 4, cell.frame.height / 5, cell.frame.width / 2, cell.frame.height / 2), type: .BallSpinFadeLoader, color: UIColor.grayColor(), padding: nil)
            activityIndicatorView.startAnimation()
            cell.addSubview(activityIndicatorView)
            cell.imageView.kf_setImageWithURL(imageUrl!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                
                performUIUpdatesOnMain({
                    activityIndicatorView.stopAnimation()
                    cell.imageView.alpha = 1.0
                })
                }
            )
        }
        cell.cellMaskView.hidden = !cell.selected
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VTCollectionViewCell
        cell.cellMaskView.hidden = false
        newCollectionBtn.title = "Remove Selected Pictures"
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VTCollectionViewCell
        cell.cellMaskView.hidden = true
        if let selectedItems = collectionView.indexPathsForSelectedItems() where selectedItems.count > 0 {
            newCollectionBtn.title = "New Collection"
        }
    }
    
    //MARK: Helper Methods
    private func deleteItemsFromDataSourceAtIndexPaths(indexPaths: [NSIndexPath]) {
        var selectedImages = [VTImage]()
        for indexPath : NSIndexPath in indexPaths {
            selectedImages.append(collectionViewImages![indexPath.row])
        }
        collectionViewImages = collectionViewImages?.filter { !selectedImages.contains($0) }
    }
}


//MARK: -Networking Methods
extension ImageCollectionViewController {
    
    func fetchImagesWithLocation(location: Location, page: Int) {
        CollectionFetchedOrEditted = true
        setUIEnabled(false)
        showMaskView()
        noImageLabel.hidden = true
        FlickrClient.sharedInstance.getImagesFromLocation(location, page: page) { (success, pages, images, errorMessage) in
            performUIUpdatesOnMain({ 
                if success {
                    self.setUIEnabled(true)
                    print("Fetch images from Flickr successfully.")
                    self.location!.totalPagesForImages = pages
                    if images?.count > 0 {
                        let images = VTImage.imagesForLocationFrom(images!)
                        self.collectionViewImages = images
                        self.preFetchImages(images)
                        
                        self.collectionView.reloadData()
                        self.hideMaskView()
                    } else {
                        self.noImageLabel.hidden = false
                    }
                } else {
                    self.setUIEnabled(true)
                    print("Fetch images from Flickr failed. Error: \(errorMessage)")
                }
            })
            
        }
    }
}

//MARK: -Selectors
extension ImageCollectionViewController {
    @IBAction func fetchNewCollectionOrDeleteSelectedImages(sender: AnyObject) {
        if newCollectionBtn.title == "New Collection" {
            fetchImagesWithLocation(location!, page: getRandomPageNumber())
        } else {
            CollectionFetchedOrEditted = true
            collectionView.performBatchUpdates({
                
                let selectedIndexPaths = self.collectionView.indexPathsForSelectedItems()!
                self.deleteItemsFromDataSourceAtIndexPaths(selectedIndexPaths)
                self.collectionView.deleteItemsAtIndexPaths(selectedIndexPaths)
                }, completion: { finished in
                    performUIUpdatesOnMain({ 
                        if finished {
                            self.newCollectionBtn.title = "New Collection"
                            if self.collectionViewImages?.count == 0 {
                                self.noImageLabel.hidden = false
                            }
                        }
                    })
                    
            })
        }
    }
    
}

 //MARK: Cache and CoreData Helper method
extension ImageCollectionViewController {
    private func preFetchImages(images: [VTImage]) {
        let urls = images.map { image in
            NSURL(string: image.imageUrl!)!
        }
        let prefetcher = ImagePrefetcher(urls: urls, optionsInfo: nil, progressBlock: nil) { (skippedResources, failedResources, completedResources) in
            print("Prefetch completed. \(completedResources.count) resources cached.")
        }
        prefetcher.start()
        print("Prefetch starts")
    }
    
    private func saveLocationImages() {
        if var imagesForLocation = collectionViewImages where CollectionFetchedOrEditted {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                //Remove exsitting data
                for image in (self.location?.images)! {
                    Utilities.appDelegate.stack.context.deleteObject(image as! Image)
                }
                
                for image in imagesForLocation {
                    _ = Image(url: image.imageUrl!, location: self.location!, context: Utilities.appDelegate.stack.context)
                }
                print("\(imagesForLocation.count) images created.")
                imagesForLocation.removeAll()
            }
        }
    }
    
    private func getRandomPageNumber() -> Int {
        if let totalPages = location?.totalPagesForImages {
            let pageLimit = min(totalPages.intValue, 40)
            let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
            return randomPage
        } else {
            return 1
        }
    }

}

//MARK: -UI related methods
extension ImageCollectionViewController {
    
    private func changeBackBarButtonItemTitleTo(title: String) {
        let backButton = UIBarButtonItem()
        backButton.title = title
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setupMapView(location: Location) {
        mapView.userInteractionEnabled = false
        let coordinate = CLLocationCoordinate2DMake(Double(location.latitude!), Double(location.longtitude!))
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(1.0, 1.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func setupCollectionView() {
        
        collectionView.allowsMultipleSelection = true
        let space :CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    private func setUIEnabled(enabled: Bool) {
        collectionView.userInteractionEnabled = enabled
        newCollectionBtn.enabled = enabled
    }
    
    private func showMaskView() {
        view.bringSubviewToFront(self.maskView)
        UIView.animateWithDuration(0.5, animations: {
            self.maskView.alpha = 1.0
        })
    }
    
    private func hideMaskView() {
        UIView.animateWithDuration(0.5, animations: {
            self.maskView.alpha = 0.0
            }) { (finished) in
                if finished {
                    self.view.sendSubviewToBack(self.maskView)
                }
        }
    }
}





