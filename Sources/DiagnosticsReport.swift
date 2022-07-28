//
//  DiagnosticsReport.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

#if os(OSX)
import AppKit
#endif

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

        #if os(iOS)
            let folderPath = "/\(userPath)/Desktop/Diagnostics/"
            try? FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            let filePath = folderPath + filename
            save(to: filePath)
        #else
            let folderPath = "/\(userPath)/Desktop/"
            saveUsingPanel(initialDirectoryPath: folderPath, filename: filename)
        #endif
    }

    private func save(to filePath: String) {
        guard FileManager.default.createFile(
            atPath: filePath,
            contents: data,
            attributes: [FileAttributeKey.type: mimeType.rawValue]
        ) else {
            print("Diagnostics Report could not be saved to: \(filePath)")
            return
        }

        print("Diagnostics Report saved to: \(filePath)")
    }

#if os(OSX)
    private func saveUsingPanel(initialDirectoryPath: String, filename: String) {
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.directoryURL = URL(string: initialDirectoryPath)
        savePanel.allowedFileTypes = ["html"]
        savePanel.nameFieldStringValue = filename
        savePanel.title = "Save Diagnostics Report"
        savePanel.message = "Save the Diagnostics report to the chosen location."
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { result in
            guard result == .OK, let targetURL = savePanel.url else {
                print("Saving Diagnostics report cancelled or failed")
                return
            }
            self.save(to: targetURL.path)
            NSWorkspace.shared.activateFileViewerSelecting([targetURL])
        }
    }
#endif
}
