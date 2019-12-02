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
        html += "<link rel=\"stylesheet\" href=\"/Users/antoinevanderlee/Desktop/Diagnostics/style.css\">"
        html += "</head>"
        return html
    }
}
