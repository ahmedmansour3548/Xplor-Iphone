//
//  FogOverlay.swift
//  Xplor
//

import MapKit
import SwiftUI

struct FogOverlay: View {

    let discoveredTiles: Set<GridTile>
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
            // Grid sizes
            //----------------------------------

            let tileSize = GridTile.tileSize

            let zoneSize =
                GridTile.tileSize
                * Double(Zone.sizeInTiles)

            let regionSize =
                zoneSize
                * Double(Region.sizeInZones)


            //----------------------------------
            // Grid opacities
            //----------------------------------

            let tileGridOpacity =
                max(
                    0,
                    min(
                        0.25,
                        0.25 * (
                            1
                            - region.span.latitudeDelta / 0.2
                        )
                    )
                )

            let zoneGridOpacity =
                max(
                    0,
                    min(
                        0.35,
                        0.35 * (
                            1
                            - region.span.latitudeDelta / 1.5
                        )
                    )
                )

            let regionGridOpacity =
                max(
                    0,
                    min(
                        0.45,
                        0.45 * (
                            1
                            - region.span.latitudeDelta / 10.0
                        )
                    )
                )

            if tileGridOpacity > 0.001 {

                //----------------------------------
                // Vertical lines
                //----------------------------------

                var lon =
                    floor(minLon / tileSize)
                    * tileSize

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
                                .black.opacity(tileGridOpacity)
                            ),
                            lineWidth: 1
                        )
                    }

                    lon += tileSize
                }

                //----------------------------------
                // Horizontal lines
                //----------------------------------

                var lat =
                    floor(minLat / tileSize)
                    * tileSize

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
                                .black.opacity(tileGridOpacity)
                            ),
                            lineWidth: 1
                        )
                    }

                    lat += tileSize
                }
            }
            
            //----------------------------------
            // Zone grid lines
            //----------------------------------

            if zoneGridOpacity > 0.001 {

                //----------------------------------
                // Vertical lines
                //----------------------------------

                var lon =
                    floor(minLon / zoneSize)
                    * zoneSize

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
                                .black.opacity(zoneGridOpacity)
                            ),
                            lineWidth: 2
                        )
                    }

                    lon += zoneSize
                }

                //----------------------------------
                // Horizontal lines
                //----------------------------------

                var lat =
                    floor(minLat / zoneSize)
                    * zoneSize

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
                                .black.opacity(zoneGridOpacity)
                            ),
                            lineWidth: 2
                        )
                    }

                    lat += zoneSize
                }
            }

            //----------------------------------
            // Region grid lines
            //----------------------------------

            if regionGridOpacity > 0.001 {

                //----------------------------------
                // Vertical lines
                //----------------------------------

                var lon =
                    floor(minLon / regionSize)
                    * regionSize

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
                                .black.opacity(regionGridOpacity)
                            ),
                            lineWidth: 4
                        )
                    }

                    lon += regionSize
                }

                //----------------------------------
                // Horizontal lines
                //----------------------------------

                var lat =
                    floor(minLat / regionSize)
                    * regionSize

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
                                .black.opacity(regionGridOpacity)
                            ),
                            lineWidth: 4
                        )
                    }

                    lat += regionSize
                }
            }
            //----------------------------------
            // Punch holes
            //----------------------------------

            context.blendMode = .destinationOut

            for tile in discoveredTiles {

                if tile.maxLatitude < minLat || tile.minLatitude > maxLat
                    || tile.maxLongitude < minLon || tile.minLongitude > maxLon
                {

                    continue
                }

                let corners = tile.coordinates

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
