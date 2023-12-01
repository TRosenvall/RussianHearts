//
//  RoundModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

class RoundModel: Equatable, Codable {

    struct BidsByPlayer: Codable {
        var bid: Bid
        var player: PlayerModel

        init(bid: Bid, player: PlayerModel) {
            self.bid = bid
            self.player = player
        }

        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<RoundModel.BidsByPlayer.CodingKeys> = try decoder.container(keyedBy: RoundModel.BidsByPlayer.CodingKeys.self)
            self.bid = try container.decode(Bid.self, forKey: RoundModel.BidsByPlayer.CodingKeys.bid)
            self.player = try container.decode(PlayerModel.self, forKey: RoundModel.BidsByPlayer.CodingKeys.player)
        }
    }

    // MARK: - Properties
    var roundName: String
    var numberOfCardsToPlay: Int
    var bidsByPlayer: [BidsByPlayer]
    var trump: CardSuit?
    var phases: [PhaseModel] = []
    var activePhase: PhaseModel

    // MARK: - Lifecycle
    // passesToTheLeft is an indicator that the round should include a phase for passing a card left or right. If nil, that round shouldn't include a passing phase.
    init(roundName: String,
         numberOfCardsToPlay: Int,
         players: [PlayerModel],
         passesForward: Bool? = nil) {
        self.roundName = roundName
        self.numberOfCardsToPlay = numberOfCardsToPlay
        self.bidsByPlayer = []

        // Setup bidding phase
        let biddingPhase = PhaseModel(players: players,
                                      id: 0,
                                      firstPlayerId: players.first?.id)
        self.phases.append(biddingPhase)

        // Setup card transfer phase
        if let passesForward {
            let cardTransferPhase = PhaseModel(players: players, id: -1,
                                               firstPlayerId: players.first?.id,
                                               passesForward: passesForward)

            self.phases.append(cardTransferPhase)
        }

        // Iterate through players and setup phases based on player order.
        for i in 1...numberOfCardsToPlay {
            var newPhase: PhaseModel?
            if i == 1 {
                newPhase = PhaseModel(players: players,
                                      id: i,
                                      firstPlayerId: players.first?.id)
            } else {
                newPhase = PhaseModel(players: players, id: i, firstPlayerId: nil)
            }

            if let newPhase {
                self.phases.append(newPhase)
            }
        }

        let firstPhase = phases.compactMap({ phase in
            if phase.firstPlayerId != nil {
                return phase
            }
            return nil
        }).first

        guard let firstPhase
        else {
            fatalError("Round created without setting up first phase")
        }

        self.activePhase = firstPhase
    }

    // MARK: - Conformance: Equatable
    static func == (lhs: RoundModel, rhs: RoundModel) -> Bool {
        return lhs.roundName == rhs.roundName
    }

    // MARK: - Conformance: Codable
    enum CodingKeys: CodingKey {
        case roundName
        case numberOfCardsToPlay
        case bidsByPlayer
        case trump
        case phases
        case activePhase
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.roundName = try values.decode(String.self, forKey: .roundName)
        self.numberOfCardsToPlay = try values.decode(Int.self, forKey: .numberOfCardsToPlay)
        self.bidsByPlayer = try values.decode([BidsByPlayer].self, forKey: .bidsByPlayer)
        self.trump = try values.decode(CardSuit?.self, forKey: .trump)
        self.phases = try values.decode([PhaseModel].self, forKey: .phases)
        self.activePhase = try values.decode(PhaseModel.self, forKey: .activePhase)
    }
}
