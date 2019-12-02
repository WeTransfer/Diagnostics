//
//  AppMetadataReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit

struct AppMetadataReporter: DiagnosticsReporting {

    static var title: String = "App Details"
    static var diagnostics: KeyValuePairs<String, String> {
        var systemInfo = utsname()
        uname(&systemInfo)
        let hardware = Mirror(reflecting: systemInfo.machine).children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        let system = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"

        return [
            "App name": Bundle.appName,
            "App version": "\(Bundle.appVersion) (\(Bundle.appBuildNumber))",
            "Device": hardware,
            "System": system,
            "Free space": "\(UIDevice.current.freeDiskSpace) of \(UIDevice.current.totalDiskSpace)",
            "Device Language": Locale.current.languageCode ?? "Unknown",
            "App Language": Locale.preferredLanguages[0]
            ]
    }

    static func report() -> DiagnosticsChapter {
        return DiagnosticsChapter(title: title, diagnostics: diagnostics)
    }
}
