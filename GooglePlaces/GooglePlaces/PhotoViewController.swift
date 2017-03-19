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
        
        self.imageView?.sd_setImage(with: URL(string: googlePhotoURL!), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
