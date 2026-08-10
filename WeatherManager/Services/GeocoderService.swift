//
//  GeocoderService.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 06/08/26.
//

import Foundation
import MapKit
import _LocationEssentials

final class GeocoderService {

    static let shared = GeocoderService()

    private init() { }

    func getCoordinates(
        city: String,
        completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void
    ) {

        guard let request = MKGeocodingRequest(addressString: city) else {
            completion(
                .failure(
                    NSError(
                        domain: "GeocoderService",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Некорректное название города"
                        ]
                    )
                )
            )
            return
        }

        request.getMapItems { mapItems, error in

            if let error {
                completion(.failure(error))
                return
            }

            guard let coordinate = mapItems?.first?.location.coordinate else {

                completion(
                    .failure(
                        NSError(
                            domain: "GeocoderService",
                            code: -2,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Город не найден"
                            ]
                        )
                    )
                )

                return
            }

            completion(.success(coordinate))
        }
    }
}

