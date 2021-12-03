import Foundation
import MetricKit

protocol Loggable {
    /// The message to log.
    var message: String { get }

    /// An optional CSS class to add to the log. If set, the log will be surrounded with a `<p>` as well.
    var cssClass: String? { get }
}

extension Loggable {
    var cssClass: String? { nil }

    var logData: Data? {
        if let cssClass = cssClass {
            return "<p class=\"\(cssClass)\">\(message)</p>".data(using: .utf8)
        } else {
            return message.data(using: .utf8)
        }
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
                return message
            case .error(let error, let description):
                var message = "\(error) | \(error.localizedDescription)"

                if let description = description {
                    message += " | \(description)"
                }
                return "ERROR: \(message)"
            }
        }

        var cssClass: String {
            switch self {
            case .debug:
                return "debug"
            case .error:
                return "error"
            }
        }
    }

    let message: String
    let cssClass: String?

    init(_ type: LogType, file: StaticString, function: StaticString, line: UInt) {
        let date = DateFormatter.current.string(from: Date())
        let file = String(describing: file).split(separator: "/").last.map(String.init) ?? String(describing: file)
        self.message = String(format: "%@ | %@:L%@ | %@", date, file, String(line), type.message)
        self.cssClass = type.cssClass
    }
}

struct SystemLog: Loggable {
    let message: String
    let cssClass: String? = "system"

    init(line: String) {
        let date = DateFormatter.current.string(from: Date())
        message = "\(date) | SYSTEM: \(line)"
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
        "💥 Reason: \(terminationReason ?? ""), Type: \(exceptionType?.stringValue ?? ""), Code: \(exceptionCode?.stringValue ?? ""), Signal: \(signal?.stringValue ?? ""), OS: \(metaData.osVersion), Build: \(metaData.applicationBuildVersion)"
    }
}
#endif
