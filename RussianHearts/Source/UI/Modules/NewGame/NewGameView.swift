//
//  NewGameView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import SwiftUI

protocol NewGameView: View {
    var state: NewGame.State { get set }
}

struct NewGameViewImpl: NewGameView {

    // MARK: - Properties

    let theme: NewGameTheme
    @State var state: NewGame.State

    var eventHandler: ((NewGame.UIEvent) -> ())?
    @State var isOn1: Bool = false
    @State var isOn2: Bool = false
    @State var isOn3: Bool = false
    @State var isOn4: Bool = false
    @State var isOn5: Bool = false
    @State var isOn6: Bool = false

    // MARK: - Views

    var body: some View {
        NavigationStack {
            backgroundColor.overlay {

                RoundedRectangle(cornerRadius: 20)
                    .inset(by: 5)
                    .stroke(theme.moduleAccentColor, lineWidth: 5)

                VStack(alignment: .center) {
                    getNewPlayerPosition(isOn: $isOn1)
                        .border(.black, width: 2)
                    getNewPlayerPosition(isOn: $isOn2)
                    getNewPlayerPosition(isOn: $isOn3)
                    getNewPlayerPosition(isOn: $isOn4)
                    getNewPlayerPosition(isOn: $isOn5)
                    getNewPlayerPosition(isOn: $isOn6)
                }
            }
            .cornerRadius(20)
        }
        .navigationTitle("New Game")
        .onAppear {
            Logger.default.log("New Game View Did Appear")

            eventHandler?(.didAppear)
        }
    }

    func getNewPlayerPosition(isOn: Binding<Bool>) -> some View {
        GeometryReader { geometry in
            HStack(alignment: .center, content: {
                Text("Thing")
                Spacer()
                Toggle("", isOn: isOn)
            })
            .frame(maxWidth: geometry.size.width, minHeight: 0)
            .background(isOn.wrappedValue ? .red : .blue)
        }
        .padding([.leading, .trailing], 10)
    }

    func getButton(title: String, event: NewGame.UIEvent, disabled: Bool = false) -> some View {
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
