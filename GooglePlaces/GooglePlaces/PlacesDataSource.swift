//
//  PlacesDataSource.swift
//  GooglePlaces
//
//  Created by Aniket Ghode on 18/03/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit
import TRON
import SwiftyJSON

class PlacesDataSource : NSObject, JSONDecodable{
    
    var places : [Place]
    
    required init(json: JSON) throws {
        print("JSON Serialization completed \(json)")
        places = [Place]()
        if let array = json["predictions"].array {
            for placeJson in array {
                let name = placeJson["description"].stringValue
                let placeID = placeJson["place_id"].stringValue
                let placeFound = Place(name: name, placeId: placeID, googlePhotoURLs: [], longitude: 0.0, lattitude: 0.0)
                places.append(placeFound)
            }
        }
        print("PDS number of places \(places.count)")
    }
}
