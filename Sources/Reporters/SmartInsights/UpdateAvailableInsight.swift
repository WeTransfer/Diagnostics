//
//  UpdateAvailableInsight.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 09/02/2022.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation
import Combine

struct UpdateAvailableInsight: SmartInsight {
    
    let name = "Update available"
    let result: InsightResult
    let warningThreshold: ByteCountFormatter.Units.Bytes = 1000 * 1024 * 1024 // 1GB
    
    init?() {
//        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return nil }
        let bundleIdentifier = "com.wetransfer.transfer"
        let url = URL(string: "https://itunes.apple.com/br/lookup?bundleId=\(bundleIdentifier)")!
        
        let group = DispatchGroup()
        group.enter()
        
        var appMetadata: AppMetadata?
        let cancellable = URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: AppMetadataResults.self, decoder: JSONDecoder())
            .sink { _ in
                group.leave()
            } receiveValue: { result in
                appMetadata = result.results.first
            }
        
        /// Set a timeout of 1 second to prevent the call from taking too long unexpectedly.
        /// Though: the request should be super fast since it's a small resource.
        let result = group.wait(timeout: .now() + .seconds(1))
        cancellable.cancel()
        
        guard result == .success, let appMetadata = appMetadata else {
            return nil
        }
        
        let currentVersion = Bundle.appVersion
        
        switch currentVersion.compare(appMetadata.version) {
        case .orderedSame, .orderedDescending:
            self.result = .success(message: "")
        case .orderedAscending:
            self.result = .warn(message: "The user could update to \(appMetadata.version)")
        }
    }
}

private struct AppMetadataResults: Codable {
    let results: [AppMetadata]
}

// A list of App metadata with details around a given app.
private struct AppMetadata: Codable {
    /// The current latest version available in the App Store.
    let version: String
}
