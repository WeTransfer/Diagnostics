//
//  DiagnosticsLogger.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation
import UIKit

/// A Diagnostics Logger to log messages to which will end up in the Diagnostics Report if using the default `LogsReporter`.
/// Will keep a `.txt` log in the documents directory with the latestlogs with a max size of 2 MB.
public final class DiagnosticsLogger {

    static let standard = DiagnosticsLogger()

    private lazy var location: URL = FileManager.default.documentsDirectory.appendingPathComponent("diagnostics_log.txt")
    private let inputPipe: Pipe = Pipe()
    private let outputPipe: Pipe = Pipe()
    private let queue: DispatchQueue = DispatchQueue(label: "com.wetransfer.diagnostics.logger", qos: .utility, target: .global(qos: .utility))

    private var logSize: ByteCountFormatter.Units.Bytes!
    private let maximumSize: ByteCountFormatter.Units.Bytes = 2 * 1024 * 1024 // 2 MB
    private let trimSize: ByteCountFormatter.Units.Bytes = 100 * 1024 // 100 KB
    private let minimumRequiredDiskSpace: ByteCountFormatter.Units.Bytes = 500 * 1024 * 1024 // 500 MB

    private var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "GMT")!
        return formatter
    }()

    /// Whether the logger is setup and ready to use.
    private var isSetup: Bool = false

    /// Whether the logger is setup and ready to use.
    public static func isSetUp() -> Bool {
        return standard.isSetup
    }

    /// Sets up the logger to be ready for usage. This needs to be called before any log messages are reported.
    /// This method also starts a new session.
    public static func setup() throws {
        try standard.setup()
    }

    /// Logs the given message for the diagnostics report.
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The file from which the log is send. Defaults to `#file`.
    ///   - function: The functino from which the log is send. Defaults to `#function`.
    ///   - line: The line from which the log is send. Defaults to `#line`.
    public static func log(message: String, file: String = #file, function: String = #function, line: UInt = #line) {
        standard.log(message: message, file: file, function: function, line: line)
    }

    /// Logs the given error for the diagnostics report.
    /// - Parameters:
    ///   - error: The error to log.
    ///   - description: An optional description parameter to add extra info about the error.
    ///   - file: The file from which the log is send. Defaults to `#file`.
    ///   - function: The functino from which the log is send. Defaults to `#function`.
    ///   - line: The line from which the log is send. Defaults to `#line`.
    public static func log(error: Error, description: String? = nil, file: String = #file, function: String = #function, line: UInt = #line) {
        var message = "\(error) | \(error.localizedDescription)"

        if let description = description {
            message += " | \(description)"
        }

        standard.log(message: "ERROR: \(message)", file: file, function: function, line: line)
    }
}

// MARK: - Setup & Logging
extension DiagnosticsLogger {
    /// Reads the log and converts it to a `Data` object.
    func readLog() -> Data? {
        guard isSetup else {
            assertionFailure()
            return nil
        }

        return queue.sync { try? Data(contentsOf: location) }
    }

    /// Removes the log file.
    func deleteLogs() throws {
        guard FileManager.default.fileExists(atPath: location.path) else { return }
        try? FileManager.default.removeItem(atPath: location.path)
    }

    private func setup() throws {
        if !FileManager.default.fileExists(atPath: location.path) {
            try FileManager.default.createDirectory(atPath: FileManager.default.documentsDirectory.path, withIntermediateDirectories: true, attributes: nil)
            guard FileManager.default.createFile(atPath: location.path, contents: nil, attributes: nil) else {
                assertionFailure("Unable to create the log file")
                return
            }
        }

        let fileHandle = try FileHandle(forReadingFrom: location)
        fileHandle.seekToEndOfFile()
        logSize = Int64(fileHandle.offsetInFile)
        setupPipe()
        isSetup = true
        startNewSession()
    }

    private func startNewSession() {
        queue.async {
            let date = self.formatter.string(from: Date())
            let appVersion = "\(Bundle.appVersion) (\(Bundle.appBuildNumber))"
            let system = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
            let locale = Locale.preferredLanguages[0]

            let message = date + "\n" + "System: \(system)\nLocale: \(locale)\nVersion: \(appVersion)\n\n"

            if self.logSize == 0 {
                self.log(message)
            } else {
                self.log("\n\n---\n\n\(message)")
            }
        }
    }

    private func log(message: String, file: String = #file, function: String = #function, line: UInt = #line) {
        guard isSetup else { return assertionFailure() }

        queue.async {
            let date = self.formatter.string(from: Date())
            let file = file.split(separator: "/").last.map(String.init) ?? file
            let output = String(format: "%@ | %@:L%@ | %@\n", date, file, String(line), message)
            self.log(output)
        }
    }

    private func log(_ output: String) {
        guard
            let data = output.data(using: .utf8),
            let fileHandle = (try? FileHandle(forWritingTo: location)) else {
                return assertionFailure()
        }

        // Make sure we have enough disk space left. This prevents a crash due to a lack of space.
        guard UIDevice.current.freeDiskSpaceInBytes > minimumRequiredDiskSpace else { return }

        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
        logSize += Int64(data.count)
        trimLinesIfNecessary()
    }

    private func trimLinesIfNecessary() {
        guard logSize > maximumSize else { return }

        guard
            var data = try? Data(contentsOf: self.location, options: .mappedIfSafe),
            !data.isEmpty,
            let newline = "\n".data(using: .utf8) else {
                return assertionFailure()
        }

        var position: Int = 0
        while (logSize - Int64(position)) > (maximumSize - trimSize) {
            guard let range = data.firstRange(of: newline, in: position ..< data.count) else { break }
            position = range.startIndex.advanced(by: 1)
        }

        logSize -= Int64(position)
        data.removeSubrange(0 ..< position)

        guard (try? data.write(to: location, options: .atomic)) != nil else {
            return assertionFailure()
        }
    }
}

// MARK: - System logs
private extension DiagnosticsLogger {

    func setupPipe() {
        guard !isRunningTests else { return }

        let pipeReadHandle = inputPipe.fileHandleForReading

        // Copy the STDOUT file descriptor into our output pipe's file descriptor
        // So we can write the strings back to STDOUT and it shows up again in the Xcode console.
        dup2(STDOUT_FILENO, outputPipe.fileHandleForWriting.fileDescriptor)

        // Send all output (STDOUT and STDERR) to our `Pipe`.
        dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)

        // Observe notifications from our input `Pipe`.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePipeNotification(_:)),
            name: FileHandle.readCompletionNotification,
            object: pipeReadHandle
        )

        // Start asynchronously monitoring our `Pipe`.
        pipeReadHandle.readInBackgroundAndNotify()
    }

    @objc func handlePipeNotification(_ notification: Notification) {
        defer {
            // You have to call this again to continuously receive notifications.
            inputPipe.fileHandleForReading.readInBackgroundAndNotify()
        }

        guard
            let data = notification.userInfo?[NSFileHandleNotificationDataItem] as? Data,
            let string = String(data: data, encoding: .utf8) else {
                assertionFailure()
                return
        }

        outputPipe.fileHandleForWriting.write(data)

        queue.async {
            string.enumerateLines(invoking: { (line, _) in
                self.log("SYSTEM: \(line)\n")
            })
        }
    }
}

private extension FileManager {
    var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func fileExistsAndIsFile(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        if fileExists(atPath: path, isDirectory: &isDirectory) {
            return !isDirectory.boolValue
        } else {
            return false
        }
    }
}
