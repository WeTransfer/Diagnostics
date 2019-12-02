//
//  DiagnosticReportGeneratorTests.swift
//  DiagnosticsTests
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import XCTest
@testable import Diagnostics

final class DiagnosticReportGeneratorTests: XCTestCase {

    /// It should correctly generate HTML from the reporters.
    func testHTMLGeneration() {
        let reporters = [DiagnosticsReporter.DefaultReporter.appMetadata.reporter]
        let reporter = DiagnosticsReporter(reporters: reporters)
        let generator = DiagnosticReportGenerator(reporter: reporter)
        let html = String(data: generator.generate().data, encoding: .utf8)

        let expectedHTML = "<h3>App Details</h3><ul><li><b>App name</b>xctest</li></ul>"

        XCTAssertEqual(html, expectedHTML)
    }

}
