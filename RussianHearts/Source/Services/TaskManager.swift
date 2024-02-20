//
//  TaskManager.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 12/27/23.
//

import Dispatch

///------

protocol UseCaseManaging {
    func execute<T: UseCase>(_ useCase: T?, completion: ((T.ResultType) -> Void)?)
    func execute(_ useCase: (any UseCase)?, completion: ((UseCaseResultType) -> Void)?)
}

///------

class UseCaseManager: UseCaseManaging {

    // MARK: - Properties

    // I don't like having a singleton instance here, but I need my managers to be accessible from anywhere and they need to be able to share the same instance of
    static let sharedInstance: UseCaseManaging = UseCaseManager()

    private var _tasks: [any UseCase] = []
    private var _isRunning: Bool = false
    private let serialQueue = DispatchQueue(label: "com.RussianHearts.UseCaseManagerQueue")

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Conformance: UseCaseManaging

    // Adding new Tasks within the function chain called here will cause those Tasks to be run
    // out of the synchronized task ordering.
    func execute<T: UseCase>(
        _ useCase: T?,
        completion: ((T.ResultType) -> Void)? = nil
    ) {
        guard let useCase else { return }

        serialQueue.async {
            let useCase = useCase.with(completion: completion)
            self._tasks.append(useCase)

            if !self._isRunning {
                self.doSynchronousTasks()
            }
        }
    }

    func execute(
        _ useCase: (any UseCase)?,
        completion: ((UseCaseResultType) -> Void)?
    ) {
        guard let useCase else { return }

        serialQueue.async {
            let useCase = useCase.with(completion: completion)
            self._tasks.append(useCase)

            if !self._isRunning {
                self.doSynchronousTasks()
            }
        }
    }

    // MARK: - Helpers

    private func doSynchronousTasks() {
        // Set the isRunning property to true to prevent more than one task from running at a time.
        _isRunning = true

        // If there are no tasks, reset the isRunning property and return out of the function
        if _tasks.isEmpty {
            _isRunning = false
            return
        }

        // Get the first task in the list
        let task = _tasks.removeFirst()

        Task {
            // Run the task
            await task.execute()
            
            self.serialQueue.async {
                // Repeat
                self.doSynchronousTasks()
            }
        }
    }
}
