//
//  LocationHelper.swift
//  OpenWeatherData
//
//  Created by James Hager on 4/6/22.
//

import Foundation
import CoreLocation

enum LocationHelper {
    
    static func getCoords(for addressString: String, completion: @escaping (Result<CLLocationCoordinate2D, LocationError>) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let coordinate = placemarks?.first?.location?.coordinate else { return completion(.failure(.noPlacemark))}
            
            completion(.success(coordinate))
        }
    }
}
