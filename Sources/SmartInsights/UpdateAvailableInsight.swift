//
//  UpdateAvailableInsight.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 09/02/2022.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation
import Combine

/// Uses the bundle identifier to fetch latest version information and provides insights into whether
/// an app update is available.
struct UpdateAvailableInsight: SmartInsightProviding {

    let name = "Update available"
    let result: InsightResult

    private var urlSessionAppMetadataPublisher: (URL) -> AnyPublisher<AppMetadataResults, Error> = { url in
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: AppMetadataResults.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    init?(
        bundleIdentifier: String? = Bundle.main.bundleIdentifier,
        currentVersion: String = Bundle.appVersion,
        appMetadataPublisher: AnyPublisher<AppMetadataResults, Error>? = nil,
        itunesRegion: String = Locale.current.regionCode ?? "us"
    ) {
        guard let bundleIdentifier = bundleIdentifier else { return nil }
        let url = URL(string: "https://itunes.apple.com/\(itunesRegion)/lookup?bundleId=\(bundleIdentifier)")!

        let group = DispatchGroup()
        group.enter()

        var appMetadata: AppMetadata?
        let publisher = appMetadataPublisher ?? urlSessionAppMetadataPublisher(url)
        let cancellable = publisher
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
