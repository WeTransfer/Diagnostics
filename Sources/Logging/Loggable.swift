import Foundation
import MetricKit

enum LoggableCSSClass: String {
    case debug, error, system
}

protocol Loggable {
    /// The date of the log event. If set, it will be prepended to the log message in the right format.
    var date: Date? { get }

    /// Any prefix to add before the actual message.
    var prefix: String? { get }

    /// The message to log.
    var message: String { get }

    /// An optional CSS class to add to the log. If set, the log will be surrounded with a `<p>` as well.
    var cssClass: LoggableCSSClass? { get }
}

extension Loggable {
    var date: Date? { nil }
    var prefix: String? { nil }
    var cssClass: LoggableCSSClass? { nil }

    var logData: Data? {
        if let cssClass = cssClass {
            return "<p class=\"\(cssClass)\">\(logMessage)</p>\n".data(using: .utf8)
        } else {
            return "\(message)\n".data(using: .utf8)
        }
    }

    private var logMessage: String {
        var messages: [String] = []
        if let date = date {
            let date = DateFormatter.current.string(from: date)
            messages.append("<span class=\"log-date\">\(date)</span>")
        }
        if let prefix = prefix {
            messages.append("<span class=\"log-prefix\">\(prefix)</span>")
        }
        messages.append("<span class=\"log-message\">\(self.message)</span>")
        return messages.joined(separator: "<span class=\"log-separator\"> | </span>")
    }
}

struct NewSession: Loggable {
    let message: String

    init() {
        let date = DateFormatter.current.string(from: Date())
        let appVersion = "\(Bundle.appVersion) (\(Bundle.appBuildNumber))"
        let system = "\(Device.systemName) \(Device.systemVersion)"
        let locale = Locale.preferredLanguages[0]

        /// We start with `\n\n---\n\n` for backwards compatibility since it's
        /// used for splitting the log into sections.
        var message = "\n\n---\n\n<summary><div class=\"session-header\">"
        message += "<p><span>Date: </span>\(date)</p>"
        message += "<p><span>System: </span>\(system)</p>"
        message += "<p><span>Locale: </span>\(locale)</p>"
        message += "<p><span>Version: </span>\(appVersion)</p>"
        message += "</div></summary>"
        self.message = message
    }
}

struct LogItem: Loggable {
    enum LogType {
        case debug(message: String)
        case error(error: Error, description: String?)

        var message: String {
            switch self {
            case .debug(let message):
                return message.addingHTMLEncoding()
            case .error(let error, let description):
                var message = "\(error) | \(error.localizedDescription)"

                if let description = description {
                    message += " | \(description)"
                }

                return "ERROR: \(message)".addingHTMLEncoding()
            }
        }

        var cssClass: LoggableCSSClass {
            switch self {
            case .debug:
                return .debug
            case .error:
                return .error
            }
        }
    }

    let date: Date? = Date()
    let prefix: String?
    let message: String
    let cssClass: LoggableCSSClass?

    init(_ type: LogType, file: String, function: String, line: UInt) {
        let file = String(describing: file).split(separator: "/").last.map(String.init) ?? String(describing: file)
        prefix = "\(file):L\(line)"
        self.message = type.message
        self.cssClass = type.cssClass
    }
}

struct SystemLog: Loggable {
    let date: Date? = Date()
    let message: String
    let cssClass: LoggableCSSClass? = .system

    init(line: String) {
        message = "SYSTEM: \(line)"
    }
}

struct ExceptionLog: Loggable {
    let message: String

    init(_ exception: NSException, description: String) {
        let message = """

        ---

        🚨 CRASH:
        Description: \(description)
        Exception name: \(exception.name.rawValue)
        Reason: \(exception.reason ?? "nil")

            \(Thread.callStackSymbols.joined(separator: "\n"))

        ---

        """

        self.message = message
    }
}

#if os(iOS)
@available(iOS 14.0, *)
extension MXDiagnosticPayload: Loggable {
    var message: String {
        """

            ---
            MXDIAGNOSTICS RECEIVED:
            \(logDescription)
            ---

            """
    }
}

@available(iOS 14.0, *)
extension MXDiagnosticPayload {
    var logDescription: String {
        var logs: [String] = []
        logs.append(contentsOf: crashDiagnostics?.compactMap { $0.logDescription } ?? [])
        return logs.joined(separator: "\n")
    }
}

@available(iOS 14.0, *)
extension MXCrashDiagnostic {
    var logDescription: String {
        return """
        💥  Reason: \(terminationReason ?? "")
            Type: \(exceptionType?.stringValue ?? "")
            Code: \(exceptionCode?.stringValue ?? "")
            Signal: \(signal?.stringValue ?? "")
            OS: \(metaData.osVersion)
            Build: \(metaData.applicationBuildVersion)

        \(callStackTree.logDescription)
        """
    }
}

@available(iOS 14.0, *)
extension MXCallStackTree {
    var logDescription: String {
        let jsonData = jsonRepresentation()

        guard let object = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) else {
            return "Error: Call Stack Tree could not be parsed into a JSON string."
        }

        return String(decoding: data, as: UTF8.self)
    }
}
#endif
