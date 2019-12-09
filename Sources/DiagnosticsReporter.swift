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
        html += footer()
        html += "</body>"

        let data = html.data(using: .utf8)!
        return DiagnosticsReport(filename: "Diagnostics-Report.html", data: data)
    }

    private static func header() -> HTML {
        var html = "<head>"
        html += "<title>\(Bundle.appName) - Diagnostics Report</title>"
        html += style()
        html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
        html += "</head>"
        return html
    }

    private static func footer() -> HTML {
        return """
        <footer>
          Built using <a href="https://github.com/WeTransfer/Diagnostics">Diagnostics</a> by <a href="https://wetransfer.com">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" class="footer-logo">
            <path d="M51.4 46.8c4.6 0 8-1.4 9.9-3.4 1-1.1 2.1-2.8 1.3-4.1-.7-1.1-1.9-1.4-3.3-.7-1.5.7-3.1 1.1-4.8 1.1-1.7 0-3.3-.5-4.6-1.6-1.2-1.2-1.9-2.8-1.8-4.5 0-.4.3-.5.8-.1 1.7 1.1 3.6 1.6 5.6 1.5 4.6 0 8.7-3.1 8.7-7.9 0-5.1-4.8-8.8-12-8.8-8.1 0-14.4 5.2-14.4 14-.1 8.3 5.4 14.5 14.6 14.5zm-33.5-8.6c.9 0 1.4.5 2 1.4l2.6 4.1c1 1.6 1.8 2.7 3.7 2.7s2.8-.8 3.7-2.9c1.4-3.2 2.6-6.6 3.4-10 1.2-4.7 1.7-7.7 1.7-10.1s-.8-3.8-3.4-4.3c-4.5-.7-9.2-1.1-13.8-1-4.6 0-9.2.3-13.8 1-2.6.5-3.4 1.9-3.4 4.3s.5 5.3 1.7 10.1c.9 3.4 2 6.8 3.4 10 .9 2.1 1.8 2.9 3.7 2.9s2.7-1.1 3.7-2.7l2.6-4.1c.9-.9 1.4-1.4 2.2-1.4z"/>
          </svg>
        </a>
        </footer>
"""
    }

    static func style() -> HTML {
        /// To add Swift Package Manager support we're adding the CSS directly here. This is because we can't add resources to packages in SPM.
        return """
        <style>body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale;font-size:1em;line-height:1.3em;margin:50px 50px 20px;color:#17181a}h1{margin:10px 0 20px;font-weight:400}h3{display:block;font-weight:400;font-size:20px;margin:0 0 10px}p{font-size:14px;margin:0 0 10px;display:block}p:last-child,ul:last-child{margin-bottom:0}pre{overflow:scroll}.container{display:flex;justify-content:space-between;flex-direction:row-reverse;max-width:960px;margin:0 auto}.main-content{width:calc(100% - 190px)}.nav-container{width:180px}.nav-container nav{position:fixed;border-radius:4px}.nav-container nav ul{margin:0}.nav-container nav ul li{margin-bottom:5px;display:block}.nav-container nav ul li:last-child{margin-bottom:0}.nav-container nav ul li a{font-size:14px;color:#444;text-decoration:none}.nav-container nav ul li a:hover{color:#000;text-decoration:underline}.chapter{position:relative;margin-bottom:20px;padding-bottom:20px;border-bottom:1px solid #ccc}.chapter:last-child{border-bottom:0}.chapter .anchor{position:absolute;top:-20px}table th{text-align:left;padding:0 5px 0 0;font-weight:500}table td,table th{font-size:14px}footer{text-align:center;font-size:14px}footer a{color:#111}.footer-logo{width:20px;display:inline-block;vertical-align:middle}@media(max-width:768px){body{margin:20px}.container{margin:0}header h1{font-size:24px}.main-content{width:100%}.nav-container{display:none}table td,table th{display:block}table td{margin-bottom:5px}}@media (prefers-color-scheme:dark){body{background:#111;color:#f7f7f7}.chapter{border-bottom-color:rgba(255,255,255,.3)}.nav-container nav ul li a{color:rgba(255,255,255,.6)}.nav-container nav ul li a:hover{color:#fff}footer a{color:rgba(255,255,255,.85)}footer a:hover{color:#fff}.footer-logo path{fill:#f7f7f7}}</style>
        """
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
