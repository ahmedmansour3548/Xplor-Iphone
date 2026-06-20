//
//  ExplorationManager.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/20/26.
//

import Foundation
import CoreLocation
internal import Combine

class ExplorationManager: ObservableObject {

    @Published var discoveredCells: Set<GridCell> = []

    private let saveKey = "DiscoveredCells"

    init() {
        load()
    }

    func updateLocation(_ location: CLLocation) {

        let cell = gridCell(for: location)

        if !discoveredCells.contains(cell) {

            discoveredCells.insert(cell)

            save()
        }
    }

    func gridCell(for location: CLLocation) -> GridCell {

        let cellSize = 0.001

        let x = Int(location.coordinate.latitude / cellSize)
        let y = Int(location.coordinate.longitude / cellSize)

        return GridCell(x: x, y: y)
    }

    private func save() {

        if let data = try? JSONEncoder().encode(
            Array(discoveredCells)
        ) {

            UserDefaults.standard.set(
                data,
                forKey: saveKey
            )
        }
    }

    private func load() {

        guard let data =
            UserDefaults.standard.data(
                forKey: saveKey
            )
        else {
            return
        }

        if let cells =
            try? JSONDecoder().decode(
                [GridCell].self,
                from: data
            ) {

            discoveredCells = Set(cells)
        }
    }
}
