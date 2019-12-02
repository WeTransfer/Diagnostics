//
//  DiagnosticReportGenerator.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public struct DiagnosticReportGenerator {

    private let reporters: [DiagnosticsReporting.Type]

    public init(reporter: DiagnosticsReporter) {
        self.reporters = reporter.reporters
    }

    public func generate() -> DiagnosticsReport {
        var html = "<html>"
        html += header()
        
        reporters.forEach { (reporter) in
            html += reporter.report().html()
        }

        let data = html.data(using: .utf8)!
        return DiagnosticsReport(filename: "DiagnosticsReport.html", data: data)
    }

    private func header() -> HTML {
        var html = "<head>"
        html += "<title>\(Bundle.appName) - Diagnostics Report</title>"
        html += style()
        html += "</head>"
        return html
    }

    private func style() -> HTML {
        let bundle = Bundle(for: DiagnosticsReporter.self)
        let cssFile = bundle.url(forResource: "style", withExtension: "css")!
        let css = try! String(contentsOf: cssFile, encoding: .utf8)
        return "<style>\(css)</style>"
    }
}
