//
//  ContentView.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/20/26.
//

import SwiftUI
import MapKit

struct ContentView: View {

    @StateObject private var locationManager = LocationManager()
    @StateObject private var explorationManager = ExplorationManager()
    
    @State private var cameraPosition: MapCameraPosition =
        .userLocation(
            followsHeading: true,
            fallback: .automatic
        )

    var body: some View {

        ZStack(alignment: .bottom) {

            Map(position: $cameraPosition) {

                if let location = locationManager.location {

                    Annotation(
                        "You",
                        coordinate: location.coordinate
                    ) {

                        Image(systemName: "location.north.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .background(.blue)
                            .clipShape(Circle())
                            .foregroundStyle(.white)
                            .rotationEffect(
                                .degrees(locationManager.heading)
                            )

                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                locationManager.requestLocationPermission()
            }
            .onChange(of: locationManager.location) { _, newLocation in

                if let location = newLocation {

                    explorationManager.updateLocation(location)

                }
            }

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
                        "Discovered Cells: \(explorationManager.discoveredCells.count)"
                    )

                } else {

                    Text("Waiting for location...")

                }

            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .padding()

        }
    }
}

#Preview {
    ContentView()
}
