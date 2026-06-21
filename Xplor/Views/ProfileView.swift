//
//  ProfileView.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/21/26.
//


import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var settingsManager:
        SettingsManager

    var body: some View {

        NavigationStack {

            Form {

                Section("Developer") {

                    Toggle(
                        "Debug Mode",
                        isOn: $settingsManager.debugMode
                    )

                }

            }
            .navigationTitle("Profile")

        }
    }
}
