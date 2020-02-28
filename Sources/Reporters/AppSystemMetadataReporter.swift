//
//  AppSystemMetadataReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit

/// Reports App and System specific metadata like OS and App version.
public struct AppSystemMetadataReporter: DiagnosticsReporting {

    public enum MetadataKey: String, CaseIterable {
        case appName = "App name"
        case appDisplayName = "App Display Name"
        case appVersion = "App version"
        case device = "Device"
        case system = "System"
        case freeSpace = "Free space"
        case deviceLanguage = "Device Language"
        case appLanguage = "App Language"
    }

    static let hardwareName: [String : String] = [
        "iPhone7,1"  : "iPhone 6 Plus",
        "iPhone7,2"  : "iPhone 6",
        "iPhone8,1"  : "iPhone 6s",
        "iPhone8,2"  : "iPhone 6s Plus",
        "iPhone8,4"  : "iPhone SE",
        "iPhone9,1"  : "iPhone 7",
        "iPhone9,2"  : "iPhone 7 Plus",
        "iPhone9,3"  : "iPhone 7",
        "iPhone9,4"  : "iPhone 7 Plus",
        "iPhone10,1" : "iPhone 8",
        "iPhone10,2" : "iPhone 8 Plus",
        "iPhone10,3" : "iPhone X",
        "iPhone10,4" : "iPhone 8",
        "iPhone10,5" : "iPhone 8 Plus",
        "iPhone10,6" : "iPhone X",
        "iPhone11,2" : "iPhone XS",
        "iPhone11,4" : "iPhone XS Max",
        "iPhone11,6" : "iPhone XS Max",
        "iPhone11,8" : "iPhone XR",
        "iPhone12,1" : "iPhone 11",
        "iPhone12,3" : "iPhone 11 Pro",
        "iPhone12,5" : "iPhone 11 Pro Max"
    ]

    static var title: String = "App & System Details"
    static var diagnostics: [String: String] {
        var systemInfo = utsname()
        uname(&systemInfo)
        var hardware = Mirror(reflecting: systemInfo.machine).children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        if let hardwareName = hardwareName[hardware] {
            hardware += " (\(hardwareName))"
        }

        let system = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"

        let metadata: [String: String] = [
            MetadataKey.appName.rawValue: Bundle.appName,
            MetadataKey.appDisplayName.rawValue: Bundle.appDisplayName,
            MetadataKey.appVersion.rawValue: "\(Bundle.appVersion) (\(Bundle.appBuildNumber))",
            MetadataKey.device.rawValue: hardware,
            MetadataKey.system.rawValue: system,
            MetadataKey.freeSpace.rawValue: "\(UIDevice.current.freeDiskSpace) of \(UIDevice.current.totalDiskSpace)",
            MetadataKey.deviceLanguage.rawValue: Locale.current.languageCode ?? "Unknown",
            MetadataKey.appLanguage.rawValue: Locale.preferredLanguages[0]
            ]
        return metadata
    }

    public static func report() -> DiagnosticsChapter {
        return DiagnosticsChapter(title: title, diagnostics: diagnostics)
    }
}
