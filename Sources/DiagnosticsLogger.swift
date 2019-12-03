//
//  DiagnosticsLogger.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

/// A Diagnostics Logger to log messages to which will end up in the Diagnostics Report if using the default `LogsReporter`.
/// Will keep a `.txt` log in the documents directory with the latestlogs with a max size of 2 MB.
public final class DiagnosticsLogger {

    static let standard = DiagnosticsLogger()

    private let location: URL
    private let pipe: Pipe
    private let queue: DispatchQueue = DispatchQueue(label: "com.wetransfer.diagnostics.logger", qos: .utility, target: .global(qos: .utility))

    private var logSize: ByteCountFormatter.Units.Bytes
    private let maximumSize: ByteCountFormatter.Units.Bytes = 2 * 1024 * 1024 // 2 MB
    private let trimSize: ByteCountFormatter.Units.Bytes = 100 * 1024 // 100 KB

    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "GMT")!
        return formatter
    }()

    private init() {
        location = FileManager.default.documentsDirectory.appendingPathComponent("diagnostics_log.txt")

        do {
            if !FileManager.default.fileExistsAndIsFile(atPath: location.path) {
                try? FileManager.default.removeItem(at: location)
                try "".write(to: location, atomically: true, encoding: .utf8)
            }

            let fileHandle = try FileHandle(forReadingFrom: location)
            fileHandle.seekToEndOfFile()
            logSize = Int64(fileHandle.offsetInFile)

        } catch {
            assertionFailure("Failed setting up DiagnosticsLogger")
            logSize = -1
        }

        pipe = Pipe()
        setupPipe()
    }

    /// Reads the log and converts it to a `Data` object.
    func readLog() -> Data? {
        return queue.sync { try? Data(contentsOf: location) }
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

    /// Logs the given message for the diagnostics report.
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The file from which the log is send. Defaults to `#file`.
    ///   - function: The functino from which the log is send. Defaults to `#function`.
    ///   - line: The line from which the log is send. Defaults to `#line`.
    public static func log(error: Error, file: String = #file, function: String = #function, line: UInt = #line) {
        let message = "\(error) | \(error.localizedDescription)"
        standard.log(message: "ERROR: \(message)", file: file, function: function, line: line)
    }
}

extension DiagnosticsLogger {
    private func log(message: String, file: String = #file, function: String = #function, line: UInt = #line) {
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

private extension DiagnosticsLogger {

    func setupPipe() {
        // Send all output (STDOUT and STDERR) to our `Pipe`.
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)

        // Observe notifications from our `Pipe`.
        let readHandle = pipe.fileHandleForReading
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePipeNotification(_:)),
            name: FileHandle.readCompletionNotification,
            object: readHandle
        )

        // Start asynchronously monitoring our `Pipe`.
        readHandle.readInBackgroundAndNotify()
    }

    @objc func handlePipeNotification(_ notification: Notification) {
        defer {
            // You have to call this again to continuously receive notifications.
            pipe.fileHandleForReading.readInBackgroundAndNotify()
        }

        guard
            let data = notification.userInfo?[NSFileHandleNotificationDataItem] as? Data,
            let string = String(data: data, encoding: .utf8) else {
                assertionFailure()
                return
        }

        queue.async {
            string.enumerateLines(invoking: { (line, _) in
                self.log(message: "SYSTEM: \(line)")
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
