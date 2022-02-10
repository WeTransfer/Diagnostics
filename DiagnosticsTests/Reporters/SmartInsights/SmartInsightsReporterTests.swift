//
//  SmartInsightsReporterTests.swift
//  
//
//  Created by Antoine van der Lee on 10/02/2022.
//

import XCTest
@testable import Diagnostics

final class SmartInsightsReporterTests: XCTestCase {

    func testSmartInsightsChapter() throws {
        let reporter = SmartInsightsReporter()
        let chapter = reporter.report()
        XCTAssertEqual(chapter.title, "Smart Insights")
        let insightsDictionary = try XCTUnwrap(chapter.diagnostics as? [String: String])
        XCTAssertFalse(insightsDictionary.isEmpty)
    }
}
