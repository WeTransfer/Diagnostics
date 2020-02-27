//
//  LogsReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

/// Creates a report chapter for all system and custom logs captured with the `DiagnosticsLogger`.
struct LogsReporter: DiagnosticsReporting {

    static var title: String = "Logs"
    static var diagnostics: String {
        guard let data = DiagnosticsLogger.standard.readLog(), let logs = String(data: data, encoding: .utf8) else {
            return "Parsing the log failed"
        }

        let sessions = logs.addingHTMLEncoding().components(separatedBy: "\n\n---\n\n")
        return sessions.reversed().joined(separator: "\n\n---\n\n")
    }

    static func report() -> DiagnosticsChapter {
        return DiagnosticsChapter(title: "Logs", diagnostics: diagnostics, formatter: self)
    }
}

extension LogsReporter: HTMLFormatting {
    static func format(_ diagnostics: Diagnostics) -> HTML {
        return "<pre>\(diagnostics)</pre>"
    }
}
