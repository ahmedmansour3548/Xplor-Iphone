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

    @Published var discoveredTiles: Set<GridTile> = []
    @Published var tilesDiscoveredToday = 0
    
    @Published var completedZones: Set<Zone> = []
    @Published var completedRegions: Set<Region> = []
    
    var totalTilesDiscovered: Int {

        discoveredTiles.count

    }
    
    private let saveKey = "DiscoveredTiles"
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

        let currentTile = gridTile(for: location)

        var newTilesDiscovered = 0

        for xOffset in -1...1 {
            for yOffset in -1...1 {

                let nearbyTile = GridTile(
                    x: currentTile.x + xOffset,
                    y: currentTile.y + yOffset
                )

                if !discoveredTiles.contains(nearbyTile) {

                    discoveredTiles.insert(nearbyTile)

                    newTilesDiscovered += 1

                }
            }
        }

        if newTilesDiscovered > 0 {

            save()

            updateCompletions(
                around: currentTile
            )

            tilesDiscoveredToday += newTilesDiscovered

            UserDefaults.standard.set(
                tilesDiscoveredToday,
                forKey: todayCountKey
            )
        }
    }

    func gridTile(for location: CLLocation) -> GridTile {

        let tileSize = 0.001

        let x = Int(location.coordinate.latitude / tileSize)
        let y = Int(location.coordinate.longitude / tileSize)

        return GridTile(x: x, y: y)
    }
    

    func zoneForTile(for tile: GridTile) -> Zone {

        Zone(
            x: tile.x / Zone.sizeInTiles,
            y: tile.y / Zone.sizeInTiles
        )
    }
    
    func regionForZone(for zone: Zone) -> Region {

        Region(
            x: zone.x / Region.sizeInZones,
            y: zone.y / Region.sizeInZones
        )
    }
    
    func discoveredTileCount(
        in targetZone: Zone
    ) -> Int {

        discoveredTiles.filter {

            self.zoneForTile(for: $0) == targetZone

        }.count
    }
    
    func completedZoneCount(
        in region: Region
    ) -> Int {

        completedZones.filter {

            self.regionForZone(for: $0) == region

        }.count
    }
    
    func updateCompletions(
        around tile: GridTile
    ) {

        let currentZone = zoneForTile(for: tile)

        let tileCount =
            discoveredTileCount(
                in: currentZone
            )

        if tileCount == 256 {

            completedZones.insert(
                currentZone
            )

            print(
                "ZONE COMPLETED:",
                currentZone
            )
        }

        let currentRegion =
            regionForZone(for: currentZone)

        let zoneCount =
            completedZoneCount(
                in: currentRegion
            )

        if zoneCount == 64 {

            completedRegions.insert(
                currentRegion
            )

            print(
                "REGION COMPLETED:",
                currentRegion
            )
        }
    }
    
    private func save() {

        if let data = try? JSONEncoder().encode(
            Array(discoveredTiles)
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

        if let tiles =
            try? JSONDecoder().decode(
                [GridTile].self,
                from: data
            ) {

            discoveredTiles = Set(tiles)
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

        discoveredTiles.removeAll()

        UserDefaults.standard.removeObject(
            forKey: saveKey
        )
        
        completedZones.removeAll()
        completedRegions.removeAll()

        tilesDiscoveredToday = 0

        UserDefaults.standard.removeObject(
            forKey: todayCountKey
        )

    }
}
