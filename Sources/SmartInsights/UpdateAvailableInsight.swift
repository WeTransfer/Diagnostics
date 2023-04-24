//
//  UpdateAvailableInsight.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 09/02/2022.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

/// Uses the bundle identifier to fetch latest version information and provides insights into whether
/// an app update is available.
struct UpdateAvailableInsight: SmartInsightProviding {

    let name = "Update available"
    let result: InsightResult

    init?(
        bundleIdentifier: String? = Bundle.main.bundleIdentifier,
        currentVersion: String = Bundle.appVersion,
        itunesRegion: String = Locale.current.regionCode ?? "us",
        appMetadataCompletion: (() -> Result<AppMetadataResults, Error>)? = nil
    ) {
        guard let bundleIdentifier else { return nil }
        let url = URL(string: "https://itunes.apple.com/\(itunesRegion)/lookup?bundleId=\(bundleIdentifier)")!

        let group = DispatchGroup()
        group.enter()

        var appMetadata: AppMetadata?
        let request = URLRequest(url: url)
        if let appMetadataCompletion {
            group.leave()
            switch appMetadataCompletion() {
            case .success(let result):
                appMetadata = result.results.first
            case .failure:
                return nil
            }
        } else {
            let task = URLSession.shared.dataTask(with: request) { data, _, _ in
                group.leave()
                if let data {
                    let result = try? JSONDecoder().decode(AppMetadataResults.self, from: data)
                    appMetadata = result?.results.first
                }
            }

            /// Set a timeout of 1 second to prevent the call from taking too long unexpectedly.
            /// Though: the request should be super fast since it's a small resource.
            let result = group.wait(timeout: .now() + .seconds(1))
            task.cancel()

            guard result == .success else {
                return nil
            }
        }

        guard let appMetadata else {
            return nil
        }

        switch currentVersion.compare(appMetadata.version) {
        case .orderedSame:
            self.result = .success(message: "The user is using the latest app version \(appMetadata.version)")
        case .orderedDescending:
            self.result = .success(message: "The user is using a newer version \(currentVersion)")
        case .orderedAscending:
            self.result = .warn(message: "The user could update to \(appMetadata.version)")
        }
    }
}

struct AppMetadataResults: Codable {
    let results: [AppMetadata]
}

// A list of App metadata with details around a given app.
struct AppMetadata: Codable {
    /// The current latest version available in the App Store.
    let version: String
}
