//
//  EntityNamespace.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import Foundation

///------

enum CodingErrors: String, Error {
    case unableToRetrieveData
    case entityNotFound
    case missingType
}

enum DataStorageType {
    case local
    case cloud
}

///------

enum CompletionState: Codable, Equatable {
    case active
    case complete(date: Date)
}

///------

protocol Entity: Model {

    associatedtype ModuleState

    static var persistID: String { get }
    var id: UUID { get }
    var gameStates: [ModuleState]? { get }
    var completionState: CompletionState? { get }
}

///------

class RHEncoder: JSONEncoder, Codable {}
class RHDecoder: JSONDecoder, Codable {}
class RHFileManager: FileManager, Codable {}

///------

protocol CodingContainerType: Codable {
    init?(_ value: Any?)
    func value() -> Codable
}

indirect enum TypeContainer: CodingContainerType {

    typealias AssociatedEntity = DefaultEntity

    // Primitives

    case int(Int)
    case string(String)

    // Entity

    case entityAccessor(EntityAccessor)
    case launchEntity(LaunchEntity)
    case mainMenuEntity(MainMenuEntity)
    case newGameEntity(NewGameEntity)
    case gameEntity(GameEntity)

    // Use Cases

    case gameServiceUseCases(GameService.UseCase)
    case loadSavedData(LoadSavedData)
    case retrieveGameState(RetrieveGameState)

    // Add other cases for additional types as needed

    init?(_ value: Any?) {
        guard value is Codable, value != nil else { return nil }

        if let value = value as? Int {
            self = .int(value)
        } else if let value = value as? String {
            self = .string(value)
        } else if let value = value as? EntityAccessor {
            self = .entityAccessor(value)
        } else if let value = value as? LoadSavedData {
            self = .loadSavedData(value)
        } else if let value = value as? LaunchEntity {
            self = .launchEntity(value)
        } else if let value = value as? MainMenuEntity {
            self = .mainMenuEntity(value)
        } else if let value = value as? NewGameEntity {
            self = .newGameEntity(value)
        } else if let value = value as? GameEntity {
            self = .gameEntity(value)
        } else if let value = value as? RetrieveGameState {
            self = .retrieveGameState(value)
        } else if let value = value as? GameService.UseCase {
            self = .gameServiceUseCases(value)
        } else {
            // Add other cases for additional types as needed
            Logger.default.logFatal("Missing Type In TypeContainer: \(value.self.debugDescription)")
        }
    }

    func value() -> Codable {
        switch self {
        case .int(let value): return value
        case .string(let value): return value
        case .entityAccessor(let value): return value
        case .loadSavedData(let value): return value
        case .retrieveGameState(let value): return value
        case .launchEntity(let value): return value
        case .mainMenuEntity(let value): return value
        case .newGameEntity(let value): return value
        case .gameEntity(let value): return value
        case .gameServiceUseCases(let value): return value
        // Add other cases for additional types as needed
        }
    }
}

///------

extension Global {
    enum GetActiveEntityUseCaseResult<T: Entity>: UseCaseResultType {
        case success(T)
        case error(GetActiveEntityUseCaseErrors)
    }

    enum GetActiveEntityUseCaseErrors: Error {
        case noLaunchStateRetrieved
    }

    ///------

    struct GetActiveEntityUseCase<T: Entity>: UseCase {

        // MARK: - Properties

        typealias ResultType = GetActiveEntityUseCaseResult
        typealias AssociatedEntity = T

        let id: UUID
        let entityAccessor: CodingContainer? // With type EntityAccessing
        let completion: ((GetActiveEntityUseCaseResult<T>) -> Void)?

        // MARK: - Lifecycle

        internal init(with base: GetActiveEntityUseCase?, id: UUID?) {
            self.init(base: base, id: id)
        }

        internal init(
            base: GetActiveEntityUseCase,
            completion: ((GetActiveEntityUseCaseResult<T>) -> Void)? = nil
        ) {
            self.id = base.id
            self.entityAccessor = base.entityAccessor
            self.completion = completion
        }

        init(
            base: GetActiveEntityUseCase? = nil,
            id: UUID? = nil,
            entityAccessor: (any EntityAccessing)? = nil,
            completion: ((GetActiveEntityUseCaseResult<T>) -> Void)? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.entityAccessor = CodingContainer(entityAccessor) ?? base?.entityAccessor
            self.completion = completion ?? base?.completion
        }

        // MARK: - Conformance: Model

        func validate() throws -> GetActiveEntityUseCase {
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
                    let entity: T = try await entityAccessor.loadActiveEntity()
                    completion(.success(entity))
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

    static func getActive<T: Entity>(
        using entityAccessor: (any EntityAccessing)? = nil,
        completion: @escaping ((Global.GetActiveEntityUseCaseResult<T>) -> Void)
    ) throws {
        let accessor = try entityAccessor ?? EntityAccessor.Builder.build()
        let getActiveEntityUseCase = try GetActiveEntityUseCase<T>.Builder
            .with(entityAccessor: accessor)
            .build()

        UseCaseManager.sharedInstance.execute(getActiveEntityUseCase, completion: completion)
    }
}

extension GenericBuilder {
    func with<U: Entity>(
        entityAccessor: (any EntityAccessing)?
    ) -> GenericBuilder<Global.GetActiveEntityUseCase<T.AssociatedEntity>> where T == Global.GetActiveEntityUseCase<U> {
        let newBase = Global.GetActiveEntityUseCase<T.AssociatedEntity>(base: base, entityAccessor: entityAccessor)
        return GenericBuilder<Global.GetActiveEntityUseCase<T.AssociatedEntity>>(base: newBase)
    }
}

///------

extension Global {
    enum UpdateEntityUseCaseResult: UseCaseResultType {
        case success(any Entity)
        case error(UpdateEntityUseCaseError)
    }

    enum UpdateEntityUseCaseError: Error {
        case unknown(Error)
    }

    struct UpdateEntityUseCase: UseCase {


        // MARK: - Properties

        typealias ResultType = UpdateEntityUseCaseResult
        typealias AssociatedEntity = DefaultEntity

        let id: UUID
        let updatedEntity: CodingContainer?
        let entityAccessor: CodingContainer?
        let completion: ((UpdateEntityUseCaseResult) -> Void)?

        // MARK: - Lifecycle

        internal init(with base: UpdateEntityUseCase?, id: UUID?) {
            self.init(base: base, id: id)
        }

        internal init(base: UpdateEntityUseCase, completion: ((UpdateEntityUseCaseResult) -> Void)?) {
            self.id = base.id
            self.updatedEntity = base.updatedEntity
            self.entityAccessor = base.entityAccessor
            self.completion = completion
        }

        fileprivate init(
            base: UpdateEntityUseCase? = nil,
            id: UUID? = nil,
            updatedEntity: (any Entity)? = nil,
            entityAccessor: (any EntityAccessing)? = nil,
            completion: ((ResultType) -> Void)? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.updatedEntity = CodingContainer(updatedEntity) ?? base?.updatedEntity
            self.entityAccessor = CodingContainer(entityAccessor) ?? base?.entityAccessor
            self.completion = completion ?? base?.completion
        }

        // MARK: - Conformance: Model

        func validate() throws -> UpdateEntityUseCase {
            return self
        }

        // MARK: - Conformance: UseCase

        func execute() async {
            Logger.default.log("Executing Update Entity Use Case")

            // Persist Entity
            guard let updatedEntity = updatedEntity?.value() as? (any Entity)
            else { Logger.default.logFatal("Unable To Update Entity, No Entity Found") }

            guard let entityAccessor = entityAccessor?.value() as? (any EntityAccessing)
            else { Logger.default.logFatal("Unable To Update Entity, No Entity Accessor Found") }

            guard let completion
            else { Logger.default.logFatal("Misisng Output On Update Entity Use Case For Type \(updatedEntity.self)") }

            do {
                if try await entityAccessor.validateEntity(updatedEntity) {
                    try await entityAccessor.update(entity: updatedEntity)
                } else {
                    try await entityAccessor.save(entity: updatedEntity)
                }

                completion(.success(updatedEntity))
            } catch {
                completion(.error(.unknown(error)))
            }
        }

        // MARK: - Conformance: Codable

        enum CodingKeys: String, CodingKey {
            case id
            case updatedEntity
            case entityAccessor
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try values.decode(ID.self, forKey: .id)
            self.updatedEntity = try values.decode(CodingContainer.self, forKey: .updatedEntity)
            self.entityAccessor = try values.decode(CodingContainer.self, forKey: .entityAccessor)
            self.completion = nil
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(updatedEntity, forKey: .updatedEntity)
            try container.encode(entityAccessor, forKey: .entityAccessor)
        }
    }

    static func updateEntity(
        _ newEntity: any Entity,
        using entityAccessor: (any EntityAccessing)? = nil,
        completion: @escaping ((Global.UpdateEntityUseCaseResult) -> Void)
    ) throws {
        let accessor = try entityAccessor ?? EntityAccessor.Builder.build()
        let updateEntityUseCase = try UpdateEntityUseCase.Builder
            .with(updatedEntity: newEntity)
            .with(entityAccessor: accessor)
            .build()

        UseCaseManager.sharedInstance.execute(updateEntityUseCase, completion: completion)
    }
}

extension GenericBuilder where T == Global.UpdateEntityUseCase {
    func with(updatedEntity: any Entity) -> GenericBuilder<Global.UpdateEntityUseCase> {
        let newBase = Global.UpdateEntityUseCase(base: base, updatedEntity: updatedEntity)
        return GenericBuilder<Global.UpdateEntityUseCase>(base: newBase)
    }

    func with(entityAccessor: (any EntityAccessing)?) -> GenericBuilder<Global.UpdateEntityUseCase> {
        let newBase = Global.UpdateEntityUseCase(base: base, entityAccessor: entityAccessor)
        return GenericBuilder<Global.UpdateEntityUseCase>(base: newBase)
    }
}

///------

extension Global {
    enum DeleteEntityUseCaseResult: UseCaseResultType {
        case success(any Entity)
        case error(DeleteEntityUseCaseError)
    }

    enum DeleteEntityUseCaseError: Error {
        case unknown(Error)
    }

    struct DeleteEntityUseCase: UseCase {

        // MARK: - Properties

        typealias ResultType = DeleteEntityUseCaseResult
        typealias AssociatedEntity = DefaultEntity
        let id: UUID
        let entityToDelete: CodingContainer?
        let entityAccessor: CodingContainer?
        let completion: ((DeleteEntityUseCaseResult) -> Void)?

        // MARK: - Lifecycle

        internal init(with base: DeleteEntityUseCase?, id: UUID?) {
            self.init(base: base, id: id)
        }

        internal init(base: DeleteEntityUseCase, completion: ((DeleteEntityUseCaseResult) -> Void)?) {
            self.id = base.id
            self.entityToDelete = base.entityToDelete
            self.entityAccessor = base.entityAccessor
            self.completion = completion
        }

        fileprivate init(
            base: DeleteEntityUseCase? = nil,
            id: UUID? = nil,
            entityToDelete: (any Entity)? = nil,
            entityAccessor: (any EntityAccessing)? = nil,
            completion: ((ResultType) -> Void)? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.entityToDelete = CodingContainer(entityToDelete) ?? base?.entityToDelete
            self.entityAccessor = CodingContainer(entityAccessor) ?? base?.entityAccessor
            self.completion = completion ?? base?.completion
        }

        // MARK: - Conformance: Model

        func validate() throws -> DeleteEntityUseCase {
            return self
        }

        // MARK: - Conformance: UseCase

        func execute() async {
            Logger.default.log("Executing Delete Entity Use Case")

            // Persist Entity
            guard let entityToDelete = entityToDelete?.value() as? (any Entity)
            else { Logger.default.logFatal("Unable To Delete Entity, No Entity Found") }
            
            guard let entityAccessor = entityAccessor?.value() as? (any EntityAccessing)
            else { Logger.default.logFatal("Unable To Update Entity, No Entity Accessor Found") }
            
            guard let completion
            else { Logger.default.logFatal("Misisng Output On Delete Entity Use Case For Type \(entityToDelete.self)") }
            
            do {
                if try await entityAccessor.validateEntity(entityToDelete) {
                    try await entityAccessor.delete(entity: entityToDelete)
                }

                completion(.success(entityToDelete))
            } catch {
                completion(.error(.unknown(error)))
            }
        }

        // MARK: - Conformance: Codable

        enum CodingKeys: String, CodingKey {
            case id
            case entityToDelete
            case entityAccessor
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try values.decode(ID.self, forKey: .id)
            self.entityToDelete = try values.decode(CodingContainer.self, forKey: .entityToDelete)
            self.entityAccessor = try values.decode(CodingContainer.self, forKey: .entityAccessor)
            self.completion = nil
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(entityToDelete, forKey: .entityToDelete)
            try container.encode(entityAccessor, forKey: .entityAccessor)
        }
    }

    static func deleteEntity(
        _ entityToDelete: any Entity,
        using entityAccessor: any EntityAccessing,
        completion: @escaping ((Global.DeleteEntityUseCaseResult) -> Void)
    ) throws {
        let deleteEntityUseCase = try DeleteEntityUseCase.Builder
            .with(entityToDelete: entityToDelete)
            .with(entityAccessor: entityAccessor)
            .build()

        UseCaseManager.sharedInstance.execute(deleteEntityUseCase, completion: completion)
    }
}

extension GenericBuilder where T == Global.DeleteEntityUseCase {
    func with(entityToDelete: any Entity) -> GenericBuilder<Global.DeleteEntityUseCase> {
        let newBase = Global.DeleteEntityUseCase(base: base, entityToDelete: entityToDelete)
        return GenericBuilder<Global.DeleteEntityUseCase>(base: newBase)
    }

    func with(entityAccessor: (any EntityAccessing)?) -> GenericBuilder<Global.DeleteEntityUseCase> {
        let newBase = Global.DeleteEntityUseCase(base: base, entityAccessor: entityAccessor)
        return GenericBuilder<Global.DeleteEntityUseCase>(base: newBase)
    }
}

///------

/// A base default entity.
struct DefaultEntity: Entity {

    // MARK: - Properties

    typealias ModuleState = Codable
    typealias AssociatedEntity = Self

    static let persistID: String = "com.russianhearts.defaultentity"
    let gameStates: [ModuleState]?
    let completionState: CompletionState?

    let id: UUID

    // MARK: - Lifecycle

    init(with base: Self?, id: UUID?) {
        Logger.default.logFatal("Default Entity init() Called.")
    }

    // MARK: - Conformance: Model

    func validate() throws -> DefaultEntity {
        Logger.default.logFatal("Default Entity validate() Called.")
    }

    // MARK: - Conformance: Codable

    init(from decoder: Decoder) throws {
        Logger.default.logFatal("Default Entity init(from decoder:) Called.")
    }

    func encode(to encoder: Encoder) throws {
        Logger.default.logFatal("Default Entity encode(to encoder:) Called.")
    }
}
