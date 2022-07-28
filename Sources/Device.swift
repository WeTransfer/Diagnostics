//
//  Device.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

enum Device {
    static var systemName: String {
        #if os(macOS)
        return ProcessInfo().hostName
        #else
        return UIDevice.current.systemName
        #endif
    }

    static var systemVersion: String {
        #if os(macOS)
        return ProcessInfo().operatingSystemVersionString
        #else
        return UIDevice.current.systemVersion
        #endif
    }

    static var freeDiskSpace: ByteCountFormatter.Units.GigaBytes {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    static var totalDiskSpace: ByteCountFormatter.Units.GigaBytes {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return "UNKNOWN" }

        return ByteCountFormatter.string(fromByteCount: space, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    static var freeDiskSpaceInBytes: ByteCountFormatter.Units.Bytes {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String)
                .resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey])
                .volumeAvailableCapacityForImportantUsage {
                #if swift(>=5)
                    return space
                #else
                    return space ?? 0
                #endif
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
        }
    }
}
