//
//  Place.swift
//  GooglePlaces
//
//  Created by Aniket Ghode on 18/03/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Place {
    let name: String
    let placeId: String
    let googlePhotoURLs: [String]
    let longitude : Double
    let lattitude : Double
    
}
