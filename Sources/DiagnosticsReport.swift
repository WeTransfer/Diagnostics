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

public extension DiagnosticsReport {
    /// This method can be used for debugging purposes to save the report to a `Diagnostics` folder on desktop.
    func saveToDesktop() {
        let simulatorPath = (NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true) as [String]).first!
        let simulatorPathComponents = URL(string: simulatorPath)!.pathComponents.prefix(3).filter { $0 != "/" }
        let userPath = simulatorPathComponents.joined(separator: "/")
        let path = "/\(userPath)/Desktop/Diagnostics/\(filename)"
        guard FileManager.default.createFile(atPath: path, contents: data, attributes: [FileAttributeKey.type: mimeType.rawValue]) else {
            // swiftlint:disable nslog_prohibited
            print("Diagnostics Report could not be saved to: \(path)")
            return
        }

        // swiftlint:disable nslog_prohibited
        print("Diagnostics Report saved to: \(path)")
    }
}
