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
    public enum MimeType: String {
        case html = "text/html"
    }

    /// The file name to use for the report.
    public let filename: String

    /// The MIME type of the report. Defaults to `html`.
    public let mimeType: MimeType = .html

    /// The data representation of the diagnostics report.
    public let data: Data
}
