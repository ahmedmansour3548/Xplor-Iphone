//
//  MapScreen.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/21/26.
//


import SwiftUI
import MapKit

struct MapScreen: View {

    @EnvironmentObject
    var locationManager: LocationManager
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
    @State private var enteringFollowMode = false
    @State private var followUser = false
    @State private var lastRegionCenter: CLLocationCoordinate2D?
    
    var body: some View {
        MapReader { proxy in
            ZStack(alignment: .bottom) {
                
                Map(
                    position: $cameraPosition,
                    interactionModes: .all
                ) {
                    
                    // Player marker
                    if let location = locationManager.location {
                        
                        Annotation(
                            "You",
                            coordinate: location.coordinate
                        ) {

                            PlayerAnnotation(
                                heading: locationManager.heading,
                                followUser: followUser
                            )

                        }
                    }
                }
                .onMapCameraChange(
                    frequency: .continuous
                ) { context in

                    cameraUpdateID += 1
                    visibleRegion = context.region

                    guard
                        followUser,
                        !enteringFollowMode,
                        let previous = lastRegionCenter
                    else {
                        lastRegionCenter = context.region.center
                        return
                    }

                    let latChange =
                        abs(previous.latitude - context.region.center.latitude)

                    let lonChange =
                        abs(previous.longitude - context.region.center.longitude)

                    if latChange > 0.00001 || lonChange > 0.00001 {

                        followUser = false
                        cameraPosition = .region(context.region)
                    }

                    lastRegionCenter = context.region.center

                    lastRegionCenter = context.region.center
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
                
                VStack {

                    Spacer()

                    HStack {

                        Spacer()

                        LocationButton(
                            followUser: followUser
                        ) {

                            if followUser {

                                followUser = false

                                if let location = locationManager.location {

                                    withAnimation(.easeOut(duration: 0.8)) {

                                        cameraPosition = .region(
                                            MKCoordinateRegion(
                                                center: location.coordinate,
                                                span: MKCoordinateSpan(
                                                    latitudeDelta: 0.01,
                                                    longitudeDelta: 0.01
                                                )
                                            )
                                        )
                                    }
                                }

                            } else {

                                let isCentered =
                                    locationManager.isCentered(
                                        in: visibleRegion
                                    )

                                if isCentered {

                                    enteringFollowMode = true
                                    followUser = true

                                    cameraPosition = .userLocation(
                                        followsHeading: true,
                                        fallback: .automatic
                                    )

                                    DispatchQueue.main.asyncAfter(
                                        deadline: .now() + 1.0
                                    ) {

                                        enteringFollowMode = false

                                    }

                                } else if let location = locationManager.location {

                                    withAnimation(.easeOut(duration: 0.8)) {

                                        cameraPosition = .region(
                                            MKCoordinateRegion(
                                                center: location.coordinate,
                                                span: MKCoordinateSpan(
                                                    latitudeDelta: 0.01,
                                                    longitudeDelta: 0.01
                                                )
                                            )
                                        )

                                    }
                                }
                            }

                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 90)
                    }
                }
                
                if settingsManager.debugMode {

                    DebugOverlay()
                        .environmentObject(locationManager)
                        .environmentObject(explorationManager)
                        .padding(.horizontal)
                        .padding(.bottom, 90)

                }            }
            .onAppear {
                locationManager.requestLocationPermission()
            }

            .ignoresSafeArea()
        }
    }
}
