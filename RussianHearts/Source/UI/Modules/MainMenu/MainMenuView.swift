//
//  MainMenuView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 1/30/24.
//

import SwiftUI

protocol MainMenuView: View {
    var state: MainMenu.State { get set }
}

struct MainMenuViewImpl: MainMenuView {

    // MARK: - Properties

    typealias ModuleState = MainMenu.State

    let theme: MainMenuTheme
    @State var state: MainMenu.State

    var eventHandler: ((MainMenu.UIEvent) -> Void)?

    // MARK: - Views

    var body: some View {
        NavigationStack {
            backgroundColor.overlay {

                RoundedRectangle(cornerRadius: 20)
                    .inset(by: 5)
                    .stroke(theme.moduleAccentColor, lineWidth: 5)

                ZStack {
                    VStack(alignment: .center) {
                        Spacer()
                        topRow
                        Spacer()
                        middleRow
                        Spacer()
                        bottomRow
                        Spacer()
                    }
                }
            }
            .cornerRadius(20)
        }
        .navigationTitle("Main Menu")
        .onAppear {
            Logger.default.log("Main Menu View Did Appear")

            eventHandler?(.didAppear)
        }
        .navigationBarBackButtonHidden()
    }

    var topRow: some View {
        HStack(alignment: .center) {
            Spacer()
            getButton(title: "New Game", event: .didTapNewGame)
            Spacer()
            getButton(
                title: "Continue Game",
                event: .didTapContinueGame(entity: state.gameEntity),
                disabled: !state.gameEntityExists
            )
            Spacer()
        }
        .padding([.top, .leading, .trailing], 5)
    }

    var middleRow: some View {
        HStack(alignment: .center) {
            Spacer()
            getButton(title: "Rules", event: .didTapRules)
            Spacer()
            getButton(title: "High Scores", event: .didTapHighscores)
            Spacer()
        }
        .padding([.leading, .trailing], 5)
    }

    var bottomRow: some View {
        HStack(alignment: .center) {
            Spacer()
            getButton(title: "Friends", event: .didTapFriends)
            Spacer()
            getButton(title: "Settings", event: .didTapSettings)
            Spacer()
        }
        .padding([.bottom, .leading, .trailing], 5)
    }

    func getButton(title: String, event: MainMenu.UIEvent, disabled: Bool = false) -> some View {
        Button(action: {
            eventHandler?(event)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .inset(by: 2)
                    .stroke(theme.moduleAccentColor, lineWidth: 2)

                Text(title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.clear)
                    .foregroundColor(disabled ? theme.moduleAccentColor.opacity(0.3) : theme.moduleAccentColor)
                    .cornerRadius(20)
                    .padding(5)
            }
        }
        .disabled(disabled)
    }

    var backgroundColor: Color {
        Color.blend(color1: .white, color2: theme.moduleAccentColor, intensity2: 0.03)
    }
}

extension UIColor {
    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2}
        guard l2 > 0 else { return color1}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}

extension Color {
    var Kit: UIColor {
        UIColor(self)
    }

    static func blend(color1: Color, intensity1: CGFloat = 0.5, color2: Color, intensity2: CGFloat = 0.5) -> Color {
        let color1Kit = color1.Kit
        let color2Kit = color2.Kit

        return UIColor.blend(color1: color1Kit, intensity1: intensity1, color2: color2Kit, intensity2: intensity2).UI
    }
}

extension UIColor {
    var UI: Color {
        Color(uiColor: self)
    }
}
