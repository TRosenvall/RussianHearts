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
    var trump: Card?
    var phases: [PhaseModel] = []
    var activePhase: PhaseModel

    // MARK: - Lifecycle
    init(roundName: String,
         numberOfCardsToPlay: Int,
         players: [PlayerModel]) {
        self.roundName = roundName
        self.numberOfCardsToPlay = numberOfCardsToPlay
        self.bidsByPlayer = []

        var mutatingPlayers = players

        // Setup bidding phase
        let biddingPhase = PhaseModel(players: mutatingPlayers, id: 0)
        self.phases.append(biddingPhase)

        // Iterate through players and setup phases based on player order.
        for i in 1...numberOfCardsToPlay {
            let newPhase = PhaseModel(players: mutatingPlayers, id: i)
            self.phases.append(newPhase)

            let player1 = mutatingPlayers.remove(at: 0)
            mutatingPlayers.append(player1)
        }

        self.activePhase = phases.first!
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
        self.trump = try values.decode(Card?.self, forKey: .trump)
        self.phases = try values.decode([PhaseModel].self, forKey: .phases)
        self.activePhase = try values.decode(PhaseModel.self, forKey: .activePhase)
    }
}
