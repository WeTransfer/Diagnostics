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
        ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    static var totalDiskSpace: ByteCountFormatter.Units.GigaBytes {
        ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }

    static var totalDiskSpaceInBytes: ByteCountFormatter.Units.Bytes {
        guard let space = try? URL(fileURLWithPath: NSHomeDirectory() as String)
            .resourceValues(forKeys: [URLResourceKey.volumeTotalCapacityKey])
            .volumeTotalCapacity else {
            return 0
        }
        return Int64(space)
    }

    static var freeDiskSpaceInBytes: ByteCountFormatter.Units.Bytes {
        guard let space = try? URL(fileURLWithPath: NSHomeDirectory() as String)
            .resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForOpportunisticUsageKey])
            .volumeAvailableCapacityForOpportunisticUsage else {
            return 0
        }
        return space
    }
}
