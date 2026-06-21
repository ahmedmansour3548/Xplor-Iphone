//
//  FogOverlay.swift
//  Xplor
//

import MapKit
import SwiftUI

struct FogOverlay: View {

    let discoveredCells: Set<GridCell>
    let mapProxy: MapProxy
    let cameraUpdateID: Int
    let visibleRegion: MKCoordinateRegion?

    var body: some View {

        Canvas { context, size in

            let _ = cameraUpdateID

            //----------------------------------
            // Base fog
            //----------------------------------

            context.fill(
                Path(
                    CGRect(
                        origin: .zero,
                        size: size
                    )
                ),
                with: .color(
                    .white.opacity(0.92)
                )
            )

            //----------------------------------
            // Visible region
            //----------------------------------

            guard let region = visibleRegion else {
                return
            }

            let minLat =
                region.center.latitude
                - region.span.latitudeDelta / 2

            let maxLat =
                region.center.latitude
                + region.span.latitudeDelta / 2

            let minLon =
                region.center.longitude
                - region.span.longitudeDelta / 2

            let maxLon =
                region.center.longitude
                + region.span.longitudeDelta / 2

            //----------------------------------
            // Grid lines
            //----------------------------------

            let cellSize = GridCell.cellSize

            let gridOpacity =
                max(
                    0,
                    min(
                        0.25,
                        0.25 * (1 - region.span.latitudeDelta / 0.2)
                    )
                )

            if gridOpacity > 0.001 {

                //----------------------------------
                // Vertical lines
                //----------------------------------

                var lon =
                    floor(minLon / cellSize)
                    * cellSize

                while lon <= maxLon {

                    let topCoord =
                        CLLocationCoordinate2D(
                            latitude: maxLat,
                            longitude: lon
                        )

                    let bottomCoord =
                        CLLocationCoordinate2D(
                            latitude: minLat,
                            longitude: lon
                        )

                    if let p1 =
                        mapProxy.convert(
                            topCoord,
                            to: .local
                        ),
                        let p2 =
                            mapProxy.convert(
                                bottomCoord,
                                to: .local
                            )
                    {

                        var path = Path()

                        path.move(to: p1)
                        path.addLine(to: p2)

                        context.stroke(
                            path,
                            with: .color(
                                .black.opacity(gridOpacity)
                            ),
                            lineWidth: 1
                        )
                    }

                    lon += cellSize
                }

                //----------------------------------
                // Horizontal lines
                //----------------------------------

                var lat =
                    floor(minLat / cellSize)
                    * cellSize

                while lat <= maxLat {

                    let leftCoord =
                        CLLocationCoordinate2D(
                            latitude: lat,
                            longitude: minLon
                        )

                    let rightCoord =
                        CLLocationCoordinate2D(
                            latitude: lat,
                            longitude: maxLon
                        )

                    if let p1 =
                        mapProxy.convert(
                            leftCoord,
                            to: .local
                        ),
                        let p2 =
                            mapProxy.convert(
                                rightCoord,
                                to: .local
                            )
                    {

                        var path = Path()

                        path.move(to: p1)
                        path.addLine(to: p2)

                        context.stroke(
                            path,
                            with: .color(
                                .black.opacity(gridOpacity)
                            ),
                            lineWidth: 1
                        )
                    }

                    lat += cellSize
                }
            }

            //----------------------------------
            // Punch holes
            //----------------------------------

            context.blendMode = .destinationOut

            for cell in discoveredCells {

                if cell.maxLatitude < minLat || cell.minLatitude > maxLat
                    || cell.maxLongitude < minLon || cell.minLongitude > maxLon
                {

                    continue
                }

                let corners = cell.coordinates

                guard
                    let p0 = mapProxy.convert(
                        corners[0],
                        to: .local
                    ),
                    let p1 = mapProxy.convert(
                        corners[1],
                        to: .local
                    ),
                    let p2 = mapProxy.convert(
                        corners[2],
                        to: .local
                    ),
                    let p3 = mapProxy.convert(
                        corners[3],
                        to: .local
                    )
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
