//
//  SettingsManager.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/21/26.
//

import Foundation
internal import Combine

class SettingsManager: ObservableObject {

    @Published var debugMode: Bool {

        didSet {

            UserDefaults.standard.set(
                debugMode,
                forKey: "DebugMode"
            )

        }
    }

    init() {

        self.debugMode =
            UserDefaults.standard.bool(
                forKey: "DebugMode"
            )

    }
}
