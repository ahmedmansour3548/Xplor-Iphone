//
//  MapScreen.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/21/26.
//


import SwiftUI
import MapKit

struct MapScreen: View {

    @StateObject private var locationManager = LocationManager()
    @EnvironmentObject var explorationManager:
        ExplorationManager
    @EnvironmentObject var settingsManager:
        SettingsManager
    
    @State private var cameraUpdateID = 0

    @State private var cameraPosition: MapCameraPosition =
        .userLocation(
            followsHeading: true,
            fallback: .automatic
        )

    @State private var visibleRegion: MKCoordinateRegion?

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
                .onMapCameraChange(
                    frequency: .continuous
                ) { context in
                    
                    cameraUpdateID += 1
                    visibleRegion = context.region
                    
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
                    discoveredTiles: explorationManager.discoveredTiles,
                    mapProxy: proxy,
                    cameraUpdateID: cameraUpdateID,
                    visibleRegion: visibleRegion
                )
                
                if settingsManager.debugMode {
                    
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
                .padding(.horizontal)
                .padding(.bottom, 90)
                    
                }
            }
            .onAppear {
                locationManager.requestLocationPermission()
            }
            .onChange(of: locationManager.location) { _, newLocation in
                
                if let location = newLocation {
                    
                    explorationManager.updateLocation(location)
                    
                }
            }
            .ignoresSafeArea()
        }
    }
}
