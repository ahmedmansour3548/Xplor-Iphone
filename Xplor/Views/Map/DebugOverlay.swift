//
//  DebugOverlay.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/26/26.
//

import SwiftUI
import CoreLocation

struct DebugOverlay: View {

    @EnvironmentObject
    var locationManager: LocationManager

    @EnvironmentObject
    var explorationManager: ExplorationManager

    var body: some View {

        VStack(spacing: 4) {

            if let location = locationManager.location {

                Text(
                    String(
                        format: "Lat: %.6f",
                        location.coordinate.latitude
                    )
                )

                Text(
                    String(
                        format: "Lon: %.6f",
                        location.coordinate.longitude
                    )
                )

                Text(
                    String(
                        format: "Heading: %.0f°",
                        locationManager.heading
                    )
                )

                Text(
                    "Discovered Tiles: \(explorationManager.discoveredTiles.count)"
                )

                Button("Move East 1 Tile") {

                    locationManager.setDebugLocation(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude + 0.001
                    )
                }

                Button("Reset Exploration") {

                    explorationManager.reset()

                }

            } else {

                Text("Waiting for location...")

            }

        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}
