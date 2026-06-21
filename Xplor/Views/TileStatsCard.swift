//
//  TileStatsCard.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/21/26.
//

import SwiftUI

struct TileStatsCard: View {

    let totalTiles: Int
    let todayTiles: Int

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack {

                Text(
                    "Total Tiles Uncovered"
                )
                .font(.headline)

                Spacer()

                Text(
                    totalTiles.formatted()
                )
                .font(.system(
                    size: 42,
                    weight: .bold
                ))
            }

            HStack {

                Text(
                    "Tiles uncovered today"
                )

                Spacer()

                Text("+\(todayTiles)")
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    .blue,
                    .purple
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .foregroundStyle(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
        .shadow(radius: 10)
    }
}
