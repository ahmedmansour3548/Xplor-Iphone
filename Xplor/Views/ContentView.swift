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

    @State private var cameraUpdateID = 0
    
    @State private var cameraPosition: MapCameraPosition =
        .userLocation(
            followsHeading: true,
            fallback: .automatic
        )
    
    var body: some View {
        MapReader { proxy in
        ZStack(alignment: .bottom) {
            
                Map(position: $cameraPosition) {
                    
                    // Player marker
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
                .onMapCameraChange { context in

                    cameraUpdateID += 1

                }
                .mapStyle(
                    .hybrid(
                        elevation: .flat
                    )
                )
                .colorMultiply(.gray)
                .saturation(0.15)
                .ignoresSafeArea()
            FogOverlay(
                discoveredCells: explorationManager.discoveredCells,
                mapProxy: proxy,
                cameraUpdateID: cameraUpdateID
            )
            
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
                        
                        Button("Move East 1 Cell") {
                            
                            guard let current = locationManager.location else {
                                return
                            }
                            
                            locationManager.setDebugLocation(
                                latitude: current.coordinate.latitude,
                                longitude: current.coordinate.longitude + 0.001
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
                .padding()
                
            }
            .onAppear {
                locationManager.requestLocationPermission()
            }
            .onChange(of: locationManager.location) { _, newLocation in
                
                if let location = newLocation {
                    
                    explorationManager.updateLocation(location)
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
