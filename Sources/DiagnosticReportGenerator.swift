//
//  DiagnosticReportGenerator.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public struct DiagnosticsReport {
    enum MimeType: String {
        case html = "text/html"
    }

    /// The URL pointing to the HTML file containing the report.
    let url: URL

    /// The file name to use for the report.
    let filename: String

    /// The MIME type of the report. Defaults to `html`.
    let mimeType: MimeType = .html

    /// The data representation of the diagnostics report.
    let data: Data
}

public struct DiagnosticReportGenerator {

    private let reporter: DiagnosticsReporter

    public init(reporter: DiagnosticsReporter) {
        self.reporter = reporter
    }

    public func generate() -> DiagnosticsReport {
        fatalError("This is not yet implemented")
    }

}
