//
//  GeneralInfoReporterTests.swift
//  DiagnosticsTests
//
//  Created by Antoine van der Lee on 03/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import XCTest
@testable import Diagnostics

final class GeneralInfoReporterTests: XCTestCase {

    /// It should include the title in the report.
    func testTitle() {
        XCTAssertEqual(GeneralInfoReporter.report().title, DiagnosticsReporter.reportTitle)
    }

    func testDescription() {
        let diagnostics = GeneralInfoReporter.report().diagnostics as! String
        XCTAssertEqual(diagnostics, GeneralInfoReporter.description)
    }

}
