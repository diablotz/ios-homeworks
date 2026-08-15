//
//  LocationManager.swift
//  Destination
//
//  Created by Timur Zakirov on 14/08/26.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {

    static let shared = LocationManager()

    private let manager = CLLocationManager()

    var onLocationReceived: ((CLLocationCoordinate2D) -> Void)?
    var onAuthorizationChanged: ((CLAuthorizationStatus) -> Void)?

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        manager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        let status = manager.authorizationStatus
        onAuthorizationChanged?(status)

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else { return }
        
        print("Координаты из LocationManager: \(location.coordinate.latitude), \(location.coordinate.longitude)")

        onLocationReceived?(location.coordinate)
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {

        print(error.localizedDescription)
    }
}
