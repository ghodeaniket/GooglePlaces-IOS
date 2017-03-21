//
//  Service.swift
//  GooglePlaces
//
//  Created by Aniket Ghode on 18/03/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct Service {
    
    //MARK: - Properties
    static var sharedInstance = Service()
    fileprivate let tron = TRON(baseURL: Config.baseURL)
    
    
    //MARK: - Methods
    //Fetch Google Places from Search String
    func fetchGooglePlaces(forSearchString searchString: String, completion : @escaping (PlacesDataSource?, Error?) -> ()){
        let request : APIRequest<PlacesDataSource, JSONError> = tron.request("/autocomplete/json")
        
        request.parameters = ["input":searchString, "types": "(cities)","key":Config.GooglePlacesAPIKey]
        request.perform(withSuccess: { (placesDataSource) in
            completion(placesDataSource, nil)
        }) { (err) in
            completion(nil, err)
        }
        
    }
    
    //Fetch Google Places details from place id
    func fetchPlaceDetails(location placeId: String, completion : @escaping (PlaceDetailsDataSource?, Error?) -> ()) {
        let request : APIRequest<PlaceDetailsDataSource, JSONError> = tron.request("/details/json")
        
        request.parameters = ["placeid":placeId, "key":Config.GooglePlacesAPIKey]
        request.perform(withSuccess: { (placesDetailsDataSource) in
            completion(placesDetailsDataSource, nil)
        }) { (err) in
            completion(nil, err)
        }
    }

    //MARK: - Error Class
    class JSONError : JSONDecodable {
        required init(json: JSON) throws {
            print("JSON Error")
        }
    }
}
