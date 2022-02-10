//
//  DeviceStorageInsight.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 09/02/2022.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

struct DeviceStorageInsight: SmartInsightProviding {
    
    let name = "Storage"
    let result: InsightResult
    let warningThreshold: ByteCountFormatter.Units.Bytes = 1000 * 1024 * 1024 // 1GB
    
    init() {
        let lowOnStorage = Device.freeDiskSpaceInBytes < warningThreshold
        let storageStatus = "(\(Device.freeDiskSpace) of \(Device.totalDiskSpace) left)"
        if lowOnStorage {
            result = .warn(message: "The user is low on storage \(storageStatus)")
        } else {
            result = .success(message: "The user has enough storage \(storageStatus)")
        }
    }
}
