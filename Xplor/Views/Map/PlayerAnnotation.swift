//
//  PlayerAnnotation.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/26/26.
//

import SwiftUI

struct PlayerAnnotation: View {

    let heading: Double
    let followUser: Bool

    var body: some View {

        Image(systemName: "location.north.fill")
            .font(.system(size: 32))
            .padding(8)
            .background(.blue)
            .clipShape(Circle())
            .foregroundStyle(.white)
            .rotationEffect(
                .degrees(
                    followUser ? 0 : heading
                )
            )
    }
}
