//
//  GridTile.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/20/26.
//

import Foundation
import CoreLocation

struct GridTile: Hashable, Codable {

    let x: Int
    let y: Int

    static let tileSize = 0.001

    var minLatitude: Double {
        Double(x) * Self.tileSize
    }

    var minLongitude: Double {
        Double(y) * Self.tileSize
    }

    var maxLatitude: Double {
        minLatitude + Self.tileSize
    }

    var maxLongitude: Double {
        minLongitude + Self.tileSize
    }

    var coordinates: [CLLocationCoordinate2D] {

        [
            CLLocationCoordinate2D(
                latitude: minLatitude,
                longitude: minLongitude
            ),
            CLLocationCoordinate2D(
                latitude: minLatitude,
                longitude: maxLongitude
            ),
            CLLocationCoordinate2D(
                latitude: maxLatitude,
                longitude: maxLongitude
            ),
            CLLocationCoordinate2D(
                latitude: maxLatitude,
                longitude: minLongitude
            )
        ]
    }
}
