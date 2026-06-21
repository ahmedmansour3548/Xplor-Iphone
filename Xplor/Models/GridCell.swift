//
//  GridCell.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/20/26.
//

import Foundation
import CoreLocation

struct GridCell: Hashable, Codable {

    let x: Int
    let y: Int

    static let cellSize = 0.001

    var minLatitude: Double {
        Double(x) * Self.cellSize
    }

    var minLongitude: Double {
        Double(y) * Self.cellSize
    }

    var maxLatitude: Double {
        minLatitude + Self.cellSize
    }

    var maxLongitude: Double {
        minLongitude + Self.cellSize
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
