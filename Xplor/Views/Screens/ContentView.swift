//
//  ContentView.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/20/26.
//


import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 1
    
    @EnvironmentObject
    var explorationManager: ExplorationManager

    @EnvironmentObject
    var settingsManager: SettingsManager
    
    var body: some View {

        TabView(selection: $selectedTab) {

            DataView()
                .tabItem {
                    Label("Data", systemImage: "chart.bar.fill")
                }
                .tag(0)

            MapScreen()
                .tabItem {
                    Label("Explore", systemImage: "map.fill")
                }
                .tag(1)

            ProfileView()
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
