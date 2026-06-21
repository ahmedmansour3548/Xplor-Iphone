//
//  FogOverlay.swift
//  Xplor
//

import SwiftUI
import MapKit

struct FogOverlay: View {

    let discoveredCells: Set<GridCell>
    let mapProxy: MapProxy
    let cameraUpdateID: Int

    var body: some View {

        Canvas { context, size in

            let _ = cameraUpdateID

            // Draw black fog
            context.fill(
                Path(
                    CGRect(
                        origin: .zero,
                        size: size
                    )
                ),
                with: .color(.black.opacity(0.90))
            )

            // Cut holes for every discovered cell
            context.blendMode = .destinationOut

            for cell in discoveredCells {

                let corners = cell.coordinates

                guard
                    let p0 = mapProxy.convert(corners[0], to: .local),
                    let p1 = mapProxy.convert(corners[1], to: .local),
                    let p2 = mapProxy.convert(corners[2], to: .local),
                    let p3 = mapProxy.convert(corners[3], to: .local)
                else {
                    continue
                }

                var path = Path()

                path.move(to: p0)
                path.addLine(to: p1)
                path.addLine(to: p2)
                path.addLine(to: p3)
                path.closeSubpath()

                context.fill(
                    path,
                    with: .color(.white)
                )
            }

        }
        .compositingGroup()
        .allowsHitTesting(false)
    }
}
