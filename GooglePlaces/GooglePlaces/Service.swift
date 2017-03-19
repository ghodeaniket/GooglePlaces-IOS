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
    
    //MARK: - Fetch Google Places from Search String
    func fetchGooglePlaces(forSearchString searchString: String, completion : @escaping (PlacesDataSource) -> ()){
        let request : APIRequest<PlacesDataSource, JSONError> = tron.request("/autocomplete/json")
        
        request.parameters = ["input":searchString, "types": "(cities)","key":Config.GooglePlacesAPIKey]
        request.perform(withSuccess: { (placesDataSource) in
            print("Received Data.")
            completion(placesDataSource)
        }) { (err) in
            print("Error receiving data \(err)")
        }
        
    }
    
    //MARK: - Fetch Google Places details from place id
    func fetchPlaceDetails(location placeId: String, completion : @escaping (PlaceDetailsDataSource) -> ()) {
        let request : APIRequest<PlaceDetailsDataSource, JSONError> = tron.request("/details/json")
        
        request.parameters = ["placeid":placeId, "key":Config.GooglePlacesAPIKey]
        request.perform(withSuccess: { (placesDetailsDataSource) in
            print("Received Data. \(placesDetailsDataSource.placeDetail?.name)")
            completion(placesDetailsDataSource)
        }) { (err) in
            print("Error receiving data \(err)")
        }
    }

    //MARK: - Error Class
    class JSONError : JSONDecodable {
        required init(json: JSON) throws {
            print("JSON Error")
        }
    }
}
