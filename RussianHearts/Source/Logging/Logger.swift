//
//  Logger.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 2/17/24.
//

import OSLog

enum RHLogType {
    case info
    case debug
    case warn
    case fatal
}

protocol LoggerProtocol {
    func log(_ message: String, logType: RHLogType, file: String, function: String, line: Int)
    func logFatal(_ message: String, file: String, function: String, line: Int) -> Never
}

struct Logger: LoggerProtocol {

    // MARK: - Properties

    static let `default` = Logger()

    var appLog: OSLog

    // MARK: - Lifecycle

    init() {
        self.appLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "RussianHearts")
    }

    // MARK: - Conformance: LoggerProtocol

    func log(
        _ message: String,
        logType: RHLogType = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let logMessage = String(
            format: "%@%@\n%@ - %@ [%d]\n%@",
            format(logType),
            format(.now),
            "\(URL(fileURLWithPath: file).lastPathComponent)",
            function,
            line,
            message
        )

        // Write the log message to a file
        writeLogToFile(logMessage)

        // Log to OSLog
        os_log(
            "%{public}@",
            log: appLog,
            type: transform(logType),
            logMessage
        )
    }

    func logFatal(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) -> Never {
        let logType: RHLogType = .fatal
        let logMessage = String(
            format: "%@%@\n%@ - %@ [%d]\n%@",
            format(logType),
            format(.now),
            "\(URL(fileURLWithPath: file).lastPathComponent)",
            function,
            line,
            message
        )

        // Write the log message to a file
        writeLogToFile(logMessage)

        // Log to OSLog
        os_log(
            "%{public}@",
            log: appLog,
            type: transform(logType),
            logMessage
        )

        fatalError()
    }

    // MARK: - Helpers

    private func transform(_ logType: RHLogType) -> OSLogType {
        switch logType {
        case .info: return .info
        case .debug: return .debug
        case .warn: return .error
        case .fatal: return .fault
        }
    }

    private func format(_ logType: RHLogType) -> String {
        switch logType {
        case .info: return "[INFO]: - "
        case .debug: return "[DEBUG]: - "
        case .warn: return "[WARN]: - "
        case .fatal: return "[FATAL]: - "
        }
    }

    private func format(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }

    private func writeLogToFile(_ logMessage: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let logFileURL = documentsDirectory.appendingPathComponent("\(Global.runtimeID)")

        do {
            // Check if the file exists
            let fileExists = FileManager.default.fileExists(atPath: logFileURL.path)

            if !fileExists {
                // If the file doesn't exist, create it and add the initial line
                try "Transmitted=False\n".appendToURL(fileURL: logFileURL)
            }

            // Append the log message to the file
            try logMessage.appendLineToURL(fileURL: logFileURL)
        } catch {
            print("Error writing to log file: \(error)")
        }
    }

    func markAsTransmitted() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let logFileURL = documentsDirectory.appendingPathComponent("\(Global.runtimeID)")

        do {
            // Read the contents of the file
            var fileContents = try String(contentsOf: logFileURL)

            // Update the "Transmitted" line to "Transmitted: true"
            fileContents = fileContents.replacingOccurrences(of: "Transmitted=False", with: "Transmitted=True")

            // Write the updated contents back to the file
            try fileContents.write(to: logFileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error marking as transmitted: \(error)")
        }
    }
}

extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }

    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}

extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        } else {
            try write(to: fileURL, options: .atomic)
        }
    }
}
