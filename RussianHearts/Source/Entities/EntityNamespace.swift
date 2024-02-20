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
    var states: [ModuleState]? { get }
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

    // Primitives

    case int(Int)
    case string(String)

    // Entity

    case entityAccessor(EntityAccessor)
    case launchEntity(LaunchEntity)

    // Use Cases

    case loadSavedData(LoadSavedData)
    case getActiveLaunchState(GetActiveLaunchState)

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
        } else if let value = value as? GetActiveLaunchState {
            self = .getActiveLaunchState(value)
        } else if let value = value as? LaunchEntity {
            self = .launchEntity(value)
        } else {
            // Add other cases for additional types as needed
            fatalError( CodingErrors.missingType.rawValue )
        }
    }

    func value() -> Codable {
        switch self {
        case .int(let value): return value
        case .string(let value): return value
        case .entityAccessor(let value): return value
        case .loadSavedData(let value): return value
        case .getActiveLaunchState(let value): return value
        case .launchEntity(let value): return value
        // Add other cases for additional types as needed
        }
    }
}

///------

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

    // MARK: - Static Update Call

    static func update(
        withNewEntity newEntity: any Entity,
        using entityAccessor: any EntityAccessing,
        completion: ((ResultType) -> Void)? = nil) throws {
        let updateEntityUseCase = try UpdateEntityUseCase.Builder
            .with(updatedEntity: newEntity)
            .with(entityAccessor: entityAccessor)
            .build()

        guard let completion
        else { Logger.default.logFatal("Update Entity Use Case Missing Output Completion") }

        UseCaseManager.sharedInstance.execute(updateEntityUseCase, completion: completion)
    }
}

extension GenericBuilder where T == UpdateEntityUseCase {
    func with(updatedEntity: any Entity) -> GenericBuilder<UpdateEntityUseCase> {
        let newBase = UpdateEntityUseCase(base: base, updatedEntity: updatedEntity)
        return GenericBuilder<UpdateEntityUseCase>(base: newBase)
    }

    func with(entityAccessor: (any EntityAccessing)?) -> GenericBuilder<UpdateEntityUseCase> {
        let newBase = UpdateEntityUseCase(base: base, entityAccessor: entityAccessor)
        return GenericBuilder<UpdateEntityUseCase>(base: newBase)
    }
}
