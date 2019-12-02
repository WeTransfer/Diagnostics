//
//  DiagnosticsReport.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

/// The actual diagnostics report containing the compiled data of all reporters.
public struct DiagnosticsReport {
    enum MimeType: String {
        case html = "text/html"
    }

    /// The file name to use for the report.
    let filename: String

    /// The MIME type of the report. Defaults to `html`.
    let mimeType: MimeType = .html

    /// The data representation of the diagnostics report.
    let data: Data
}
