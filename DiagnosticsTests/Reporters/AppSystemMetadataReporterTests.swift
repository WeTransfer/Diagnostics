//
//  AppSystemMetadataReporterTests.swift
//  DiagnosticsTests
//
//  Created by Antoine van der Lee on 03/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import XCTest
@testable import Diagnostics

final class AppSystemMetadataReporterTests: XCTestCase {

    /// It should correctly add the metadata.
    func testMetadata() {
        let metadata = AppSystemMetadataReporter.report().diagnostics as! KeyValuePairs<String, String>
        let dict: [String: String] = Dictionary(uniqueKeysWithValues: metadata.map { $0 })

        XCTAssertEqual(dict[AppSystemMetadataReporter.MetadataKey.appName.rawValue], Bundle.appName)
        XCTAssertEqual(dict[AppSystemMetadataReporter.MetadataKey.appVersion.rawValue], "\(Bundle.appVersion) (\(Bundle.appBuildNumber))")
        XCTAssertEqual(dict[AppSystemMetadataReporter.MetadataKey.appLanguage.rawValue], "en")

        AppSystemMetadataReporter.MetadataKey.allCases.forEach { key in
            XCTAssertNotNil(dict[key.rawValue])
        }
    }
}
