//
//  LocationDetailsViewController.swift
//  GooglePlaces
//
//  Created by Aniket Ghode on 19/03/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailsViewController: UIViewController, UICollectionViewDataSource {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "GooglePhoto"
    fileprivate let segueIdentifier = "ShowPhoto"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0) // adding border around photos at the bottom of the map
    fileprivate let itemsPerRow: CGFloat = 1 // Single Row Collection View
    var placeDetail : Place?
    var selectedPlace: Place?
    var googlePhotoURLs: [String]?

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        
        
        if let selectedPlace = self.selectedPlace {
            // Fetch details for selected place from previous screen.
            Service.sharedInstance.fetchPlaceDetails(location: selectedPlace.placeId, completion: { (placeDetailsDataSource, err) in
                if let err = err {
                    print("Error fetching place details. ", err)
                    return
                }
                
                self.placeDetail = placeDetailsDataSource!.placeDetail
                
                // Check if PlaceDetails exist or return
                guard let placeDetail = self.placeDetail else {
                    print("No data")
                    return
                }
                
                let annotation = MKPointAnnotation()
                annotation.title = placeDetail.name
                annotation.coordinate.latitude = placeDetail.lattitude
                annotation.coordinate.longitude = placeDetail.longitude
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
                
                self.googlePhotoURLs = placeDetail.googlePhotoURLs
                self.photosCollectionView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionView DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // check if URLs for photo are present
        if let googlePhotoURLs = googlePhotoURLs
        {
            return googlePhotoURLs.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        if let googlePhotoURLs = googlePhotoURLs {
            // SDWebImage provides way to put placeholder image until the image is downloaded asynchronously.
            imageView.sd_setImage(with: URL(string: googlePhotoURLs[indexPath.row]), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        return cell
    }
    
    // MARK: - Navigation - PrepareForSegue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueIdentifier {
            if let indexPath = photosCollectionView.indexPathsForSelectedItems?.first {
                let destinationController = segue.destination as! PhotoViewController
                destinationController.googlePhotoURL = googlePhotoURLs?[indexPath.row]
            }
        }
    }
}


// MARK: - UICollectionView Delegate to Update FlowLayour
extension LocationDetailsViewController : UICollectionViewDelegateFlowLayout {

    // Set the size of collection view cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.height - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // Set the margins around collection view cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
