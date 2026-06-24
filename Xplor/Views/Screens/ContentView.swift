//
//  ContentView.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/20/26.
//


import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 1
    
    @StateObject private var explorationManager =
            ExplorationManager()
    
    @StateObject private var settingsManager =
        SettingsManager()
    
    var body: some View {

        TabView(selection: $selectedTab) {

            DataView()
                .environmentObject(explorationManager)
                .environmentObject(settingsManager)
                .tabItem {
                    Label("Data", systemImage: "chart.bar.fill")
                }
                .tag(0)

            MapScreen()
                .environmentObject(explorationManager)
                .environmentObject(settingsManager)
                .tabItem {
                    Label("Explore", systemImage: "map.fill")
                }
                .tag(1)

            ProfileView()
                .environmentObject(settingsManager)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
    }
}

#Preview {

    ContentView()

}
