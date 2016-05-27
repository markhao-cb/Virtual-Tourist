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
    
    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeBackBarButtonItemTitleTo("OK")
        
        
    }

}




    //UI related methods
extension ImageCollectionViewController {
    private func changeBackBarButtonItemTitleTo(title: String) {
        let backButton = UIBarButtonItem()
        backButton.title = title
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
