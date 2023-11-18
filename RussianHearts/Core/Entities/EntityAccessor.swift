//
//  EntityAccessor.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/18/23.
//

import Foundation

class EntityAccessor: EntityAccessing {

    // MARK: - Properties
    private let fileManager: FileManager

    // MARK: - Lifecycle
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    // MARK: - Conformance: EntityAccessing
    func retrieveData(forId id: String) throws -> Data? {
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appURL = appSupportURL.appendingPathComponent(Constants.appShortName)
        let fileURL = appURL.appendingPathComponent("\(id).json")
        let data = try Data(contentsOf: fileURL)
        return data
    }
    
    func save(_ data: Data?, withId id: String) throws {
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try fileManager.createDirectory(at: appSupportURL,
                                        withIntermediateDirectories: true)

        let appURL = appSupportURL.appendingPathComponent(Constants.appShortName)
        try FileManager.default.createDirectory(at: appURL,
                                                withIntermediateDirectories: true)

        let fileURL = appURL.appendingPathComponent("\(id).json")

        try data?.write(to: fileURL)
    }

    func removeEntity(withId id: String) throws {
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try fileManager.createDirectory(at: appSupportURL,
                                        withIntermediateDirectories: true)

        let appURL = appSupportURL.appendingPathComponent(Constants.appShortName)
        try FileManager.default.createDirectory(at: appURL,
                                                withIntermediateDirectories: true)

        let fileURL = appURL.appendingPathComponent("\(id).json")
        try fileManager.removeItem(at: fileURL)
    }
}
