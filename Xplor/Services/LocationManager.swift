//
//  LocationManager.swift
//  Xplor
//

import Foundation
import CoreLocation
internal import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    let manager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var heading: Double = 0

    override init() {
        super.init()

        manager.delegate = self

        manager.desiredAccuracy = kCLLocationAccuracyBest

        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }

    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        location = locations.last
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateHeading newHeading: CLHeading
    ) {
        heading = newHeading.trueHeading
    }
}
