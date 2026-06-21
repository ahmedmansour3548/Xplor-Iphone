//
//  DataView.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/21/26.
//

import SwiftUI

struct DataView: View {

    @EnvironmentObject var explorationManager:
        ExplorationManager

    var body: some View {

        ScrollView {

            VStack(spacing: 20) {

                TileStatsCard(
                    totalTiles:
                        explorationManager
                            .discoveredCells
                            .count,

                    todayTiles:
                        explorationManager
                            .tilesDiscoveredToday
                )

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Data")
    }
}
