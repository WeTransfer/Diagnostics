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
        let metadata = AppSystemMetadataReporter.report().diagnostics as! KeyValuePairs<AppSystemMetadataReporter.MetadataKey, String>
        let dict: [AppSystemMetadataReporter.MetadataKey: String] = Dictionary(uniqueKeysWithValues: metadata.map { $0 })

        XCTAssertEqual(dict[.appName], Bundle.appName)
        XCTAssertEqual(dict[.appVersion], "\(Bundle.appVersion) (\(Bundle.appBuildNumber))")
        XCTAssertEqual(dict[.appLanguage], "en")

        AppSystemMetadataReporter.MetadataKey.allCases.forEach { key in
            XCTAssertNotNil(dict[key])
        }
    }
}
