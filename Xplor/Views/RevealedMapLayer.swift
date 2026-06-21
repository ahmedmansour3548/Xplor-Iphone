//
//  RevealedMapLayer.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/21/26.
//

import SwiftUI
import MapKit

struct RevealedMapLayer: View {

    let discoveredTiles: Set<GridTile>
    @Binding var cameraPosition: MapCameraPosition

    var body: some View {

        Map(position: $cameraPosition) {

            ForEach(
                Array(discoveredTiles),
                id: \.self
            ) { tile in

                MapPolygon(
                    coordinates: tile.coordinates
                )
                .foregroundStyle(.white)

            }

        }
        .mapStyle(.standard)
        .mask {

            Canvas { context, size in

                context.fill(
                    Path(
                        CGRect(
                            origin: .zero,
                            size: size
                        )
                    ),
                    with: .color(.white)
                )

            }

        }
    }
}
