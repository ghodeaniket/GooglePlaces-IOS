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
    var placeDetail : Place?
    var googlePhotoURLs : [String]?
    required init(json: JSON) throws {
        
        var longitude: Double?
        var lattitude: Double?
        var name: String?
        if let resultDictionary = json["result"].dictionary {
            name = resultDictionary["formatted_address"]?.stringValue
            if let geometry = resultDictionary["geometry"]?.dictionary {
                if let location = geometry["location"]?.dictionary {
                    longitude = location["lng"]?.doubleValue
                    lattitude = location["lat"]?.doubleValue
                }
            }
            
            if let photos = resultDictionary["photos"]?.array {
                googlePhotoURLs = [String]()
                for googlePhoto in photos {
                    let width = googlePhoto["width"].intValue
                    let photoReference = googlePhoto["photo_reference"].stringValue
                    let googleAPIKey = Config.GooglePlacesAPIKey
                    let googlePhotoURL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(width)&photoreference=\(photoReference)&key=\(googleAPIKey)"
                    googlePhotoURLs?.append(googlePhotoURL)
                }
            }
        }
        
        // If location longitude is not present return error
        guard let _ = longitude else {
            placeDetail = nil
            return
        }
        
        placeDetail = Place(name: name!, placeId: "", googlePhotoURLs: googlePhotoURLs ?? [], longitude: longitude!, lattitude: lattitude!)
    }
}
