//
//  XplorApp.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/20/26.
//

import SwiftUI

@main
struct XplorApp: App {

    @StateObject private var locationManager: LocationManager
    @StateObject private var explorationManager: ExplorationManager
    @StateObject private var settingsManager =
        SettingsManager()

    init() {

        let location = LocationManager()

        _locationManager =
            StateObject(wrappedValue: location)

        _explorationManager =
            StateObject(
                wrappedValue:
                    ExplorationManager(
                        locationManager: location
                    )
            )
    }

    var body: some Scene {

        WindowGroup {

            ContentView()
                .environmentObject(locationManager)
                .environmentObject(explorationManager)
                .environmentObject(settingsManager)

        }
    }
}
