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

/// Defines a Diagnostics Chapter which will end up in the report as HTML.
public struct DiagnosticsChapter {

    /// The title of the diagnostics report which will also be used as HTML anchor.
    public let title: String

    /// The `Diagnostics` to show in the chapter.
    public let diagnostics: Diagnostics

    /// Whether the title should be visibly shown.
    public let shouldShowTitle: Bool

    public init(title: String, diagnostics: Diagnostics, shouldShowTitle: Bool = true) {
        self.title = title
        self.diagnostics = diagnostics
        self.shouldShowTitle = shouldShowTitle
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
        html += "<body>"
        html += "<main class=\"container\">"

        let reportChapters = reporters.map { $0.report() }

        html += menu(using: reportChapters)
        html += mainContent(using: reportChapters)

        html += "</main>"
        html += "</body>"

        let data = html.data(using: .utf8)!
        return DiagnosticsReport(filename: "Diagnostics-Report.html", data: data)
    }

    private static func header() -> HTML {
        var html = "<head>"
        html += "<title>\(Bundle.appName) - Diagnostics Report</title>"
        html += style()
        html += "<link href=\"https://fonts.googleapis.com/css?family=Roboto&display=swap\" rel=\"stylesheet\">"
        html += "</head>"
        return html
    }

    static func style() -> HTML {
        let bundle = Bundle(for: DiagnosticsLogger.self)
        let cssFile = bundle.url(forResource: "style", withExtension: "css")!
        let css = try! String(contentsOf: cssFile, encoding: .utf8).minifiedCSS()

        return "<style>\(css)</style>"
    }

    static func menu(using chapters: [DiagnosticsChapter]) -> HTML {
        var html = "<aside class=\"nav-container\"><nav><ul>"
        chapters.forEach { chapter in
            html += "<li><a href=\"#\(chapter.title.anchor)\">\(chapter.title)</a></li>"
        }
        html += "</ul></nav></aside>"
        return html
    }

    static func mainContent(using chapters: [DiagnosticsChapter]) -> HTML {
        var html = "<div class=\"main-content\">"
        html += "<header><h1>\(reportTitle)</h1></header>"
        chapters.forEach { chapter in
            html += chapter.html()
        }
        html += "</div>"
        return html
    }
}

extension String {
    var anchor: String {
        return lowercased().replacingOccurrences(of: " ", with: "-")
    }

    func minifiedCSS() -> String {
        let components = filter { !$0.isNewline }.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
