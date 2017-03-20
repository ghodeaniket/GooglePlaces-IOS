//
//  PhotoViewController.swift
//  GooglePlaces
//
//  Created by Aniket Ghode on 19/03/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var googlePhotoURL: String?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        // SDWebImage provides way to put placeholder image until the image is downloaded asynchronously.
        // When image is displayed it is cached automatically by SDWebImageView library
        self.imageView?.sd_setImage(with: URL(string: googlePhotoURL!), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
