//
//  LocationButton.swift
//  Xplor
//
//  Created by Ahmed Mansour on 6/26/26.
//

import SwiftUI

struct LocationButton: View {

    let followUser: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            Image(
                systemName:
                    followUser
                    ? "location.fill"
                    : "location"
            )
            .font(.system(size: 22))
            .foregroundStyle(
                followUser
                ? .white
                : .primary
            )
            .frame(
                width: 56,
                height: 56
            )
            .background(
                followUser
                ? Color.blue
                : Color(.systemBackground)
            )
            .clipShape(Circle())
            .shadow(radius: 6)
        }
    }
}
