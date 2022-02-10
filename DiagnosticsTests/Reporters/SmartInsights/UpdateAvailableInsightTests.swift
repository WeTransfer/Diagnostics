//
//  UpdateAvailableInsightTests.swift
//  
//
//  Created by Antoine van der Lee on 10/02/2022.
//

import XCTest
@testable import Diagnostics
import Combine

final class UpdateAvailableInsightTests: XCTestCase {

    let exampleError = NSError(domain: UUID().uuidString, code: -1, userInfo: nil)
    let sampleBundleIdentifier = "com.wetransfer.example.app"

    func testReturningNilIfNoBundleIdentifier() {
        XCTAssertNil(UpdateAvailableInsight(bundleIdentifier: nil))
    }

    func testReturningNilIfNoAppMetadataAvailable() {
        let publisher: AnyPublisher<AppMetadataResults, Error> = Fail(error: exampleError).eraseToAnyPublisher()
        let insight = UpdateAvailableInsight(bundleIdentifier: sampleBundleIdentifier, appMetadataPublisher: publisher)
        XCTAssertNil(insight)
    }

    func testUserIsOnTheSameVersion() {
        let appMetadata = AppMetadataResults(results: [.init(version: "1.0.0")])
        let publisher: AnyPublisher<AppMetadataResults, Error> = Just(appMetadata)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let insight = UpdateAvailableInsight(bundleIdentifier: sampleBundleIdentifier, currentVersion: "1.0.0", appMetadataPublisher: publisher)
        XCTAssertEqual(insight?.result, .success(message: "The user is using the latest app version 1.0.0"))
    }

    func testUserIsOnANewerVersion() {
        let appMetadata = AppMetadataResults(results: [.init(version: "1.0.0")])
        let publisher: AnyPublisher<AppMetadataResults, Error> = Just(appMetadata)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let insight = UpdateAvailableInsight(bundleIdentifier: sampleBundleIdentifier, currentVersion: "2.0.0", appMetadataPublisher: publisher)
        XCTAssertEqual(insight?.result, .success(message: "The user is using a newer version 2.0.0"))
    }

    func testUserIsOnAnOlderVersion() {
        let appMetadata = AppMetadataResults(results: [.init(version: "2.0.0")])
        let publisher: AnyPublisher<AppMetadataResults, Error> = Just(appMetadata)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let insight = UpdateAvailableInsight(bundleIdentifier: sampleBundleIdentifier, currentVersion: "1.0.0", appMetadataPublisher: publisher)
        XCTAssertEqual(insight?.result, .warn(message: "The user could update to 2.0.0"))
    }
}
