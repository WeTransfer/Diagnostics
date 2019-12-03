//
//  AppSystemMetadataReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit

/// Reports App and System specific metadata like OS and App version.
struct AppSystemMetadataReporter: DiagnosticsReporting {

    enum MetadataKey: String, CaseIterable {
        case appName = "App name"
        case appVersion = "App version"
        case device = "Device"
        case system = "System"
        case freeSpace = "Free space"
        case deviceLanguage = "Device Language"
        case appLanguage = "App Language"
    }

    static var title: String = "App & System Details"
    static var diagnostics: KeyValuePairs<MetadataKey, String> {
        var systemInfo = utsname()
        uname(&systemInfo)
        let hardware = Mirror(reflecting: systemInfo.machine).children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        let system = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"

        let metadata: KeyValuePairs<MetadataKey, String> = [
            .appName: Bundle.appName,
            .appVersion: "\(Bundle.appVersion) (\(Bundle.appBuildNumber))",
            .device: hardware,
            .system: system,
            .freeSpace: "\(UIDevice.current.freeDiskSpace) of \(UIDevice.current.totalDiskSpace)",
            .deviceLanguage: Locale.current.languageCode ?? "Unknown",
            .appLanguage: Locale.preferredLanguages[0]
            ]
        return metadata
    }

    static func report() -> DiagnosticsChapter {
        return DiagnosticsChapter(title: title, diagnostics: diagnostics)
    }
}
