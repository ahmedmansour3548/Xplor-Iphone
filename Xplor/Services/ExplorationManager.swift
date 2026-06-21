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
    @Published var tilesDiscoveredToday = 0
    
    private let saveKey = "DiscoveredCells"
    private let todayCountKey = "TilesDiscoveredToday"

    private let todayDateKey = "TilesDiscoveredDate"

    init() {

        load()

        updateDailyCounter()

        tilesDiscoveredToday =
            UserDefaults.standard.integer(
                forKey: todayCountKey
            )
    }

    func updateLocation(_ location: CLLocation) {

        let currentCell = gridCell(for: location)

        var discoveredNewCell = false

        for xOffset in -1...1 {
            for yOffset in -1...1 {

                let nearbyCell = GridCell(
                    x: currentCell.x + xOffset,
                    y: currentCell.y + yOffset
                )

                if !discoveredCells.contains(nearbyCell) {

                    discoveredCells.insert(nearbyCell)
                    discoveredNewCell = true

                }
            }
        }

        if discoveredNewCell {
            save()
            
            tilesDiscoveredToday += 1

            UserDefaults.standard.set(
                tilesDiscoveredToday,
                forKey: todayCountKey
            )
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
    
    private func updateDailyCounter() {

        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd"

        let today =
            formatter.string(from: Date())

        let savedDate =
            UserDefaults.standard.string(
                forKey: todayDateKey
            )

        if savedDate != today {

            tilesDiscoveredToday = 0

            UserDefaults.standard.set(
                today,
                forKey: todayDateKey
            )

            UserDefaults.standard.set(
                0,
                forKey: todayCountKey
            )
        }
    }
    
    func reset() {

        discoveredCells.removeAll()

        UserDefaults.standard.removeObject(
            forKey: saveKey
        )

    }
}
