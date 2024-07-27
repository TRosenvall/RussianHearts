//
//  LoadGameUseCase.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 12/24/23.
//

import Foundation

///------

enum RetrieveGameStateUseCaseResult: UseCaseResultType {
    case success(GameState)
    case error(RetrieveGameStateUseCaseErrors)
}

enum RetrieveGameStateUseCaseErrors: Error {
    case nilGameState
    case emptyGameStates
    case unknown(Error?)
}

///------

protocol RetrieveGameStateUseCase: GameServiceUseCase {}

struct RetrieveGameState: RetrieveGameStateUseCase {

    // MARK: - Properties

    typealias AssociatedEntity = GameEntity
    typealias ResultType = RetrieveGameStateUseCaseResult

    let id: UUID
    let entityAccessor: CodingContainer? /// Of type `EntityAccessing`
    let completion: ((RetrieveGameStateUseCaseResult) -> ())?

    // MARK: - Lifecycle

    internal init(with base: RetrieveGameState?, id: UUID?) {
        self.init(base: base, id: id)
    }

    internal init(
        base: RetrieveGameState,
        completion: ((RetrieveGameStateUseCaseResult) -> Void)? = nil
    ) {
        self.id = base.id
        self.entityAccessor = base.entityAccessor
        self.completion = completion
    }

    fileprivate init(
        base: RetrieveGameState? = nil,
        id: UUID? = nil,
        entityAccessor: (any EntityAccessing)? = nil,
        completion: ((RetrieveGameStateUseCaseResult) -> ())? = nil
    ) {
        self.id = id ?? base?.id ?? UUID()
        self.entityAccessor = CodingContainer(entityAccessor) ?? base?.entityAccessor
        self.completion = completion ?? base?.completion
    }

    // MARK: - Conformance: UseCase

    func execute() async {
        // Load Entity
        if let entityAccessor = entityAccessor?.value() as? (any EntityAccessing),
           let completion {
            do {
                let entity: GameEntity? = try await entityAccessor.loadActiveEntity()

                if let gameState = entity?.gameStates?.last {
                    completion(.success(gameState))
                } else {
                    completion(.error(.emptyGameStates))
                }
            } catch {
                completion(.error(.nilGameState))
            }
        }
    }

    // MARK: - Conformance: Model

    func validate() throws -> RetrieveGameState {
        guard entityAccessor != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }

    // MARK: - Conformance: Codable

    enum CodingKeys: String, CodingKey {
        case id
        case entityAccessor
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(ID.self, forKey: .id)
        self.entityAccessor = try values.decode(CodingContainer.self, forKey: .entityAccessor)
        self.completion = nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(entityAccessor, forKey: .entityAccessor)
    }
}

extension GenericBuilder where T == RetrieveGameState {
    func with(entityAccessor: (any EntityAccessing)?) -> GenericBuilder<RetrieveGameState> {
        let newBase = RetrieveGameState(base: base, entityAccessor: entityAccessor)
        return GenericBuilder<RetrieveGameState>(base: newBase)
    }
}
