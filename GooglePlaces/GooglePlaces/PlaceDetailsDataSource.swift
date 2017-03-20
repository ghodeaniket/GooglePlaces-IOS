//
//  PlaceDetailsDataSource.swift
//  GooglePlaces
//
//  Created by Aniket Ghode on 19/03/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit
import TRON
import SwiftyJSON

class PlaceDetailsDataSource: NSObject, JSONDecodable {
    
    enum PlaceDetails: String {
        case result = "result"
        case formattedAddress = "formatted_address"
        case geometry = "geometry"
        case location = "location"
        case longitude = "lng"
        case lattitude = "lat"
    }
    
    enum GooglePhoto: String {
        case width = "width"
        case photoReference = "photo_reference"
        case photos = "photos"
    }
    
    fileprivate let photoBaseURL = "https://maps.googleapis.com/maps/api/place/photo"
    var placeDetail : Place?
    var googlePhotoURLs : [String]?
    required init(json: JSON) throws {
        super.init()
        var longitude: Double?
        var lattitude: Double?
        var name: String?
        if let resultDictionary = json[PlaceDetails.result.rawValue].dictionary {
            name = resultDictionary[PlaceDetails.formattedAddress.rawValue]?.stringValue
            if let geometry = resultDictionary[PlaceDetails.geometry.rawValue]?.dictionary {
                if let location = geometry[PlaceDetails.location.rawValue]?.dictionary {
                    longitude = location[PlaceDetails.longitude.rawValue]?.doubleValue
                    lattitude = location[PlaceDetails.lattitude.rawValue]?.doubleValue
                }
            }

            self.googlePhotoURLs = getPhotoURLs(resultDictionary: resultDictionary)
        }
        
        // If location longitude is not present return error
        guard let _ = longitude else {
            placeDetail = nil
            return
        }
        
        placeDetail = Place(name: name!, placeId: "", googlePhotoURLs: googlePhotoURLs ?? [], longitude: longitude!, lattitude: lattitude!)
    }
    
    // Get URLs for Google photos from Place Details JSON
    func getPhotoURLs(resultDictionary: Dictionary<String, JSON>) -> [String] {
        var googlePhotoURLs = [String]()
        if let photos = resultDictionary[GooglePhoto.photos.rawValue]?.array {
            for googlePhoto in photos {
                let width = googlePhoto[GooglePhoto.width.rawValue].intValue
                let photoReference = googlePhoto[GooglePhoto.photoReference.rawValue].stringValue
                let googleAPIKey = Config.GooglePlacesAPIKey
                var googlePhotoURL = photoBaseURL
                googlePhotoURL = googlePhotoURL.appending("?maxwidth="+String(width))
                googlePhotoURL = googlePhotoURL.appending("&photoreference="+photoReference)
                googlePhotoURL = googlePhotoURL.appending("&key="+googleAPIKey)
                googlePhotoURLs.append(googlePhotoURL)
            }
        }
        return googlePhotoURLs
    }
}
