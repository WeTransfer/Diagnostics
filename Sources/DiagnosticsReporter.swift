//
//  DiagnosticsReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public protocol DiagnosticsReporting {
    static func report() -> DiagnosticsChapter
}

public struct DiagnosticsChapter {
    public let title: String
    public let diagnostics: Diagnostics

    public init(title: String, diagnostics: Diagnostics) {
        self.title = title
        self.diagnostics = diagnostics
    }
}

public enum DiagnosticsReporter {

    public enum DefaultReporter: CaseIterable {
        case generalInfo
        case appSystemMetadata
        case logs
        case userDefaults

        var reporter: DiagnosticsReporting.Type {
            switch self {
            case .generalInfo:
                return GeneralInfoReporter.self
            case .appSystemMetadata:
                return AppSystemMetadataReporter.self
            case .logs:
                return LogsReporter.self
            case .userDefaults:
                return UserDefaultsReporter.self
            }
        }

        public static var allReporters: [DiagnosticsReporting.Type] {
            allCases.map { $0.reporter }
        }
    }

    /// The title that is used in the header of the web page of the report.
    static var reportTitle: String = "\(Bundle.appName) - Diagnostics Report"

    /// Creates the report by making use of the given reporters.
    /// - Parameter reporters: The reporters to use. Defaults to `DefaultReporter.allReporters`. Use this parameter if you'd like to exclude certain reports.
    public static func create(using reporters: [DiagnosticsReporting.Type] = DefaultReporter.allReporters) -> DiagnosticsReport {
        var html = "<html>"
        html += header()

        reporters.forEach { (reporter) in
            html += reporter.report().html()
        }

        let data = html.data(using: .utf8)!
        return DiagnosticsReport(filename: "Diagnostics-Report.html", data: data)
    }

    private static func header() -> HTML {
        var html = "<head>"
        html += "<title>\(Bundle.appName) - Diagnostics Report</title>"
        html += style()
        html += "</head>"
        return html
    }

    static func style() -> HTML {
        let bundle = Bundle(for: DiagnosticsLogger.self)
        let cssFile = bundle.url(forResource: "style", withExtension: "css")!
        let css = try! String(contentsOf: cssFile, encoding: .utf8).minifiedCSS()

        return "<style>\(css)</style>"
    }
}

private extension String {
    func minifiedCSS() -> String {
        let components = filter { !$0.isNewline }.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
