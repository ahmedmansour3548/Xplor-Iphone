//
//  LocationManager.swift
//  Xplor
//

import Foundation
import CoreLocation
import MapKit
internal import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    let manager = CLLocationManager()

    @Published var location: CLLocation?

    let locationSubject = PassthroughSubject<CLLocation, Never>()
    @Published var heading: Double = 0
    
    @Published var debugMode = true

    override init() {
        super.init()

        manager.delegate = self

        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = 10

        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false

        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = 10
        manager.activityType = .fitness
        
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }

    func requestLocationPermission() {

        switch manager.authorizationStatus {

        case .notDetermined:

            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse:

            manager.requestAlwaysAuthorization()

        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {

        switch manager.authorizationStatus {

        case .authorizedWhenInUse:

            manager.startUpdatingLocation()
            manager.startUpdatingHeading()

            manager.requestAlwaysAuthorization()

        case .authorizedAlways:

            manager.startUpdatingLocation()
            manager.startUpdatingHeading()

        default:
            break
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {

        guard let latest = locations.last else {
            return
        }
        
        guard latest.horizontalAccuracy >= 0,
              latest.horizontalAccuracy <= 100
        else {
            return
        }

        location = latest

        locationSubject.send(latest)

    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {

        print(
            "Location error:",
            error.localizedDescription
        )

    }
    
    func isCentered(
        in region: MKCoordinateRegion?
    ) -> Bool {

        guard
            let region,
            let location
        else {

            return false

        }

        let latDiff =
            abs(
                region.center.latitude
                - location.coordinate.latitude
            )

        let lonDiff =
            abs(
                region.center.longitude
                - location.coordinate.longitude
            )

        return
            latDiff < GridTile.tileSize
            &&
            lonDiff < GridTile.tileSize
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateHeading newHeading: CLHeading
    ) {
        heading =
            newHeading.trueHeading >= 0
            ? newHeading.trueHeading
            : newHeading.magneticHeading
    }
    
    func setDebugLocation(
        latitude: Double,
        longitude: Double
    ) {

        location = CLLocation(
            latitude: latitude,
            longitude: longitude
        )

    }
}
