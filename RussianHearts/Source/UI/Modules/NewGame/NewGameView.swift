//
//  NewGameView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import SwiftUI

protocol NewGameView: ModuleView {}

struct NewGameViewImpl<ViewModel>: NewGameView where ViewModel: NewGameViewModel {

    // MARK: - Properties

    typealias ModuleState = NewGame.State

    let theme: NewGameTheme
    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    // MARK: - Lifecycle

    init(theme: NewGameTheme, viewModel: ViewModel) {
        self.theme = theme
        self.viewModel = viewModel

        UINavigationBar.appearance().barTintColor = theme.moduleAccentColor.Kit
    }

    // MARK: - Views

    var body: some View {
        NavigationStack {
            backgroundColor.overlay {

                RoundedRectangle(cornerRadius: 20)
                    .inset(by: 5)
                    .stroke(theme.moduleAccentColor, lineWidth: 5)

                VStack(alignment: .center) {
                    if let state = viewModel.state {
                        ForEach(state.players.indices, id: \.self) { index in
                            Toggle(isOn: Binding(
                                get: { state.players[index].isHuman },
                                set: { newValue in
                                    viewModel.handleUIEvent(.didToggleIsHuman(index: index, isHuman: newValue))
                                }
                            )) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(.clear)
                                            .frame(width: 28, height: 28)
                                        Image(uiImage: state.players[index].isHuman ?
                                              UIImage(systemName: "person.circle")! : UIImage(systemName: "play.desktopcomputer")!
                                        )
                                        .renderingMode(.template)
                                        .foregroundStyle(theme.moduleAccentColor)
                                    }
                                    TextField("Name", text: Binding(
                                        get: { state.players[index].name },
                                        set: { newValue in
                                            viewModel.handleUIEvent(.didUpdateName(index: index, name: newValue))
                                        }
                                    ))
                                    .padding(.trailing, 4)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        Spacer()
                    }

                    Button {
                        viewModel.handleUIEvent(.didTapStartGameButton)
                    } label: {
                        Text("Start Game")
                            .foregroundStyle(theme.moduleAccentColor)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color.clear)
                    .overlay(
                        Capsule()
                            .stroke(theme.moduleAccentColor, lineWidth: 2)
                            .padding(.horizontal, 16)
                    )
                }
                .padding(.vertical, 22)
            }
            .cornerRadius(20)
        }
        .navigationTitle("New Game")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .renderingMode(.template)
                            .foregroundStyle(theme.moduleAccentColor)
                        Text("Back")
                            .foregroundStyle(theme.moduleAccentColor)
                    }
                }
            }
        }
        .onAppear {
            Logger.default.log("New Game View Did Appear")

            viewModel.handleUIEvent(.didAppear)
        }
    }

    // MARK: - Helpers

    var backgroundColor: Color {
        Color.blend(color1: .white, color2: theme.moduleAccentColor, intensity2: 0.03)
    }
}
