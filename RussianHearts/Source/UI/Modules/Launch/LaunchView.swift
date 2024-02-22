//
//  LaunchView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 1/30/24.
//

import SwiftUI

protocol LaunchView: View {}

struct LaunchViewImpl: LaunchView {

    // MARK: - Properties

    let theme: LaunchTheme
    @State var state: Launch.State

    var eventHandler: ((Launch.UIEvent) -> ())?

    // MARK: - Views

    var body: some View {
        NavigationStack {
            theme.moduleBackgroundColor.overlay {
                RoundedRectangle(cornerRadius: 20)
                    .inset(by: 5)
                    .stroke(theme.moduleAccentColor, lineWidth: 5)
                ZStack {
                    VStack(alignment: .center) {
                        HStack(alignment: .center) {
                            ProgressView()
                        }
                    }
                }
            }
            .cornerRadius(20)
        }
        .navigationTitle("Launch")
        .onAppear {
            Logger.default.log("Launch View Did Appear")

            eventHandler?(.didAppear)
        }
    }
}
