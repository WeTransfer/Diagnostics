//
//  UserDefaultsReporterTests.swift
//  DiagnosticsTests
//
//  Created by Antoine van der Lee on 03/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import XCTest
@testable import Diagnostics
final class UserDefaultsReporterTests: XCTestCase {

    /// It should show the user defaults in the report.
    func testReportUserDefaults() {
        let expectedValue = UUID().uuidString
        UserDefaults.standard.set(expectedValue, forKey: "test_key")
        let report = UserDefaultsReporter.report().diagnostics as! String
        XCTAssertTrue(report.contains(expectedValue))
    }

}
