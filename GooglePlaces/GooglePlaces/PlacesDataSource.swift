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
    
    // Enum for basic Place information keys    
    enum PlaceKeys : String{
        case predictions = "predictions"
        case description = "description"
        case placeId = "place_id"
    }
    
    var places : [Place]
    
    required init(json: JSON) throws {
        places = [Place]()
        if let array = json[PlaceKeys.predictions.rawValue].array {
            for placeJson in array {
                let name = placeJson[PlaceKeys.description.rawValue].stringValue
                let placeID = placeJson[PlaceKeys.placeId.rawValue].stringValue
                let placeFound = Place(name: name, placeId: placeID, googlePhotoURLs: [], longitude: 0.0, lattitude: 0.0)
                places.append(placeFound)
            }
        }
    }
}
