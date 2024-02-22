//
//  LoadSavedDataUseCase.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 2/3/24.
//

import Foundation

enum LoadSavedDataUseCaseResult: UseCaseResultType {
    case success(GameEntity)
    case error(LoadSavedDataUseCaseErrors)
}

enum LoadSavedDataUseCaseErrors: Error {
    case noGameStateRetrieved
}

///------

protocol LoadSavedDataOutput: UseCaseOutput {}

///------

protocol LoadSavedDataUseCase: UseCase where ResultType == LoadSavedDataUseCaseResult {}

struct LoadSavedData: LoadSavedDataUseCase {

    // MARK: - Properties

    typealias AssociatedEntity = LaunchEntity

    let id: UUID
    let entityAccessor: CodingContainer? // With type EntityAccessing
    var completion: ((LoadSavedDataUseCaseResult) -> Void)?

    // MARK: - Lifecycle

    internal init(with base: LoadSavedData?, id: UUID?) {
        self.init(base: base, id: id)
    }

    internal init(
        base: LoadSavedData,
        completion: ((LoadSavedDataUseCaseResult) -> Void)? = nil
    ) {
        self.id = base.id
        self.entityAccessor = base.entityAccessor
        self.completion = completion
    }

    fileprivate init(
        base: LoadSavedData? = nil,
        id: UUID? = nil,
        entityAccessor: (any EntityAccessing)? = nil,
        completion: ((ResultType) -> Void)? = nil
    ) {
        self.id = id ?? base?.id ?? UUID()
        self.entityAccessor = CodingContainer(entityAccessor) ?? base?.entityAccessor
        self.completion = completion ?? base?.completion
    }

    // MARK: - Conformance: Model

    func validate() throws -> LoadSavedData {
        guard entityAccessor != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }

    // MARK: - Conformance: LoadSaveDataUseCase

    func execute() async {
        Logger.default.log("Executing Load Saved Data Use Case")

        // Get the existing GameEntity and pass it into the output
        if let entityAccessor = entityAccessor?.value() as? (any EntityAccessing),
           let completion {
            do {
                let entity: GameEntity = try await entityAccessor.loadActiveEntity()
                completion(.success(entity))
            } catch {
                completion(.error(.noGameStateRetrieved))
            }
        }
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

extension GenericBuilder where T == LoadSavedData {
    func with(entityAccessor: (any EntityAccessing)?) -> GenericBuilder<LoadSavedData> {
        let newBase = LoadSavedData(base: base, entityAccessor: entityAccessor)
        return GenericBuilder<LoadSavedData>(base: newBase)
    }
}
