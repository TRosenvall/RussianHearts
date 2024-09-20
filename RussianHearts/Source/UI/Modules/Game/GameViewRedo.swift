////
////  GameView.swift
////  RussianHearts
////
////  Created by Timothy Rosenvall on 3/12/24.
////
//
//import SwiftUI
//
//protocol GameView: ModuleView {}
//
//struct GameViewImpl<ViewModel>: GameView, CardViewDelegate where ViewModel: GameViewModel {
//
//    // MARK: - Properties
//
//    typealias ModuleState = Game.State
//
//    let theme: GameTheme
//    @ObservedObject var viewModel: ViewModel
//    @State var frames: [CGPoint] = []
//
//    var players: [Player] {
//        guard let players = viewModel.gameState?.players,
//              !players.isEmpty
//        else { Logger.default.logFatal("Missing Players")}
//
//        return players
//    }
//
//    var activePlayer: Player? {
//        guard let player = viewModel.gameState?.activeRound?.activeTrick?.activeTurn?.activePlayer
//        else {
//            Logger.default.log("No Active Players")
//            return nil
//        }
//
//        return player
//    }
//
//    var trumpColor: Color? {
//        if let color = viewModel.gameState?.activeRound?.trump?.transformToColor().UI {
//            return color
//        }
//        return nil
//    }
//
//    var testCard: CardView? = {
//        if let card = try? NumberCard.Builder.with(suit: .blue).with(value: .eight).build().wrap() {
//            return CardView(card: card)
//        }
//        return nil
//    }()
//
//
//    // MARK: - Lifecycle
//
//    init(theme: GameTheme, viewModel: ViewModel) {
//        self.theme = theme
//        self.viewModel = viewModel
//
//        UINavigationBar.appearance().barTintColor = theme.moduleAccentColor.Kit
//    }
//
//    // MARK: - Views
//
//    var body: some View {
//        NavigationStack {
//            backgroundColor.overlay {
//                RoundedRectangle(cornerRadius: 20)
//                    .inset(by: 5)
//                    .stroke(theme.moduleAccentColor, lineWidth: 5)
//
//                VStack(alignment: .center) {
//                    // Status Bar View
//                    statusBarView
//                }
//                .padding(.vertical, 22)
//            }
//            .cornerRadius(20)
//        }
//        .navigationTitle("Game")
//        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button {
//                    print("Button")
//                } label: {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                            .renderingMode(.template)
//                            .foregroundStyle(theme.moduleAccentColor)
//                        Text("Back")
//                            .foregroundStyle(theme.moduleAccentColor)
//                    }
//                }
//            }
//        }
//        .onAppear {
//            Logger.default.log("New Game View Did Appear")
//            
//            viewModel.handleUIEvent(.didAppear)
//        }
//    }
//
//    var statusBarView: some View {
//        HStack {
//            Text(activePlayer?.name ?? "Player Name")
//                .padding(.horizontal, 2)
//                .lineLimit(1)
//            Spacer()
//            Text("Trump:")
//                .lineLimit(1)
//            Rectangle()
//                .fill(trumpColor ?? .gray)
//                .frame(width: 33, height: 33, alignment: .center)
//            Spacer()
//            Text("Current Bid: ")
//                .padding(.trailing, -2)
//            Text("\(activePlayer?.activeBid?.value ?? 0)")
//                .padding(.trailing, 2)
//            Text("Tricks Won: ")
//                .padding(.trailing, -2)
//            Text("\(activePlayer?.currentScore ?? 0)")
//                .padding(.trailing, 2)
//        }
//        .frame(height: 50)
//        .background(
//            RoundedRectangle(cornerRadius: 8)
//            .fill(
//                Color.blend(
//                    color1: theme.moduleAccentColor,
//                    intensity1: 0.03,
//                    color2: theme.moduleBackgroundColor,
//                    intensity2: 0.03
//                )
//            )
//        )
//        .padding([.leading, .trailing, .bottom])
//    }
//
//    // MARK: - Conformance
//
//    func tapped(_ cardView: CardView) {
////        if let numberCard = cardView.card?.unwrapNumberCard(),
////           let value = numberCard.value?.name,
////           let suit = numberCard.suit?.rawValue {
////            print("Card: \(value) of \(suit)s")
////        } else if let specialCard = cardView.card?.unwrapSpecialCard(),
////                  let name = specialCard.name {
////            print("Card: \(name)")
////        }
////        if cardView.selectedState == .notSelected {
////            if cardView.tappedState == .tapped {
////                cardView.tappedState = .notTapped
////            } else {
////                cardView.tappedState = .tapped
////            }
////        }
//        print("Card Tapped State: \(cardView.tappedState)")
////        print("Card Selected State: \(cardView.selectedState)")
////        print("Card Selected State Frame: \(cardView.selectedStateFrame)")
//    }
//
//    // MARK: - Helpers
//
//    var backgroundColor: Color {
//        Color.blend(color1: .white, color2: theme.moduleAccentColor, intensity2: 0.03)
//    }
////
////    func getPlayerPositionPlaceholder(for player: Player) -> CardView {
////        var cardView = CardView(player: player)
////        cardView.isUpsideDown = false
////        return cardView
////    }
////
////    func recordCardViewPosition(in frames: Binding<[CGPoint]>, using geometry: GeometryProxy) {
////        Logger.default.log("Recording Card Frame")
////
////        let frame = geometry.frame(in: .global)
////        frames.wrappedValue.append(CGPoint(x: frame.minX, y: frame.minY))
////
////        Logger.default.log(frames.wrappedValue.debugDescription)
////    }
//}
