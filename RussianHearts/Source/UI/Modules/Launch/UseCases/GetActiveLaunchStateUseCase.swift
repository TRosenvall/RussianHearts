//
//  GetActiveLaunchStateUseCase.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 2/15/24.
//

import Foundation

enum GetActiveLaunchStateUseCaseResult: UseCaseResultType {
    case success(Launch.State)
    case error(GetActiveLaunchStateUseCaseErrors)
}

enum GetActiveLaunchStateUseCaseErrors: Error {
    case noLaunchStateRetrieved
}

///------

protocol GetActiveLaunchStateUseCase: UseCase where ResultType == GetActiveLaunchStateUseCaseResult {}

struct GetActiveLaunchState: GetActiveLaunchStateUseCase {

    // MARK: - Properties

    let id: UUID
    let entityAccessor: CodingContainer? // With type EntityAccessing
    let completion: ((GetActiveLaunchStateUseCaseResult) -> Void)?

    // MARK: - Lifecycle

    internal init(with base: GetActiveLaunchState?, id: UUID?) {
        self.init(base: base, id: id)
    }

    internal init(
        base: GetActiveLaunchState,
        completion: ((GetActiveLaunchStateUseCaseResult) -> Void)? = nil
    ) {
        self.id = base.id
        self.entityAccessor = base.entityAccessor
        self.completion = completion
    }

    fileprivate init(
        base: GetActiveLaunchState? = nil,
        id: UUID? = nil,
        entityAccessor: (any EntityAccessing)? = nil,
        completion: ((ResultType) -> Void)? = nil
    ) {
        self.id = id ?? base?.id ?? UUID()
        self.entityAccessor = CodingContainer(entityAccessor) ?? base?.entityAccessor
        self.completion = completion ?? base?.completion
    }

    // MARK: - Conformance: Model

    func validate() throws -> GetActiveLaunchState {
        guard entityAccessor != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }

    // MARK: - Conformance: LoadSaveDataUseCase

    func execute() async {
        Logger.default.log("Executing Get Active Launch State Use Case")

        // Get the existing GameEntity and pass it into the output
        if let entityAccessor = entityAccessor?.value() as? (any EntityAccessing),
           let completion {
            do {
                let entity: LaunchEntity = try await entityAccessor.loadActiveEntity()

                guard let state = entity.states?.last
                else { completion(.error(.noLaunchStateRetrieved)); return }

                completion(.success(state))
            } catch {
                completion(.error(.noLaunchStateRetrieved))
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

extension GenericBuilder where T == GetActiveLaunchState {
    func with(entityAccessor: (any EntityAccessing)?) -> GenericBuilder<GetActiveLaunchState> {
        let newBase = GetActiveLaunchState(base: base, entityAccessor: entityAccessor)
        return GenericBuilder<GetActiveLaunchState>(base: newBase)
    }
}
