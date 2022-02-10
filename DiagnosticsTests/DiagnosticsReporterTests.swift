//
//  DiagnosticsReporterTests.swift
//  DiagnosticsTests
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import XCTest
@testable import Diagnostics

final class DiagnosticsReporterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        try! DiagnosticsLogger.setup()
    }

    override class func tearDown() {
        try! DiagnosticsLogger.standard.deleteLogs()
        super.tearDown()
    }

    /// It should correctly generate HTML from the reporters.
    func testHTMLGeneration() {
        let diagnosticsChapter = DiagnosticsChapter(title: UUID().uuidString, diagnostics: UUID().uuidString)
        MockedReporter.diagnosticsChapter = diagnosticsChapter
        let reporters = [MockedReporter.self]
        let report = DiagnosticsReporter.create(using: reporters)
        let html = String(data: report.data, encoding: .utf8)!

        XCTAssertTrue(html.contains("<h3>\(diagnosticsChapter.title)</h3>"))
        XCTAssertTrue(html.contains(diagnosticsChapter.diagnostics as! String))
    }

    /// It should create a chapter for each reporter.
    func testReportingChapters() {
        let report = DiagnosticsReporter.create()
        let html = String(data: report.data, encoding: .utf8)!
        let expectedChaptersCount = DiagnosticsReporter.DefaultReporter.allCases.count
        let chaptersCount = html.components(separatedBy: "<div class=\"chapter\"").count - 1
        XCTAssertEqual(expectedChaptersCount, chaptersCount)
    }

    /// It should filter using passed filters.
    func testFilters() {
        let keyToFilter = UUID().uuidString
        MockedReport.diagnostics = [keyToFilter: UUID().uuidString]
        let report = DiagnosticsReporter.create(using: [MockedReport.self], filters: [MockedFilter.self])
        let html = String(data: report.data, encoding: .utf8)!
        XCTAssertFalse(html.contains(keyToFilter))
        XCTAssertTrue(html.contains("FILTERED"))
    }

    /// It should correctly generate the header.
    func testHeaderGeneration() {
        let report = DiagnosticsReporter.create(using: [])
        let html = String(data: report.data, encoding: .utf8)!

        XCTAssertTrue(html.contains("<head>"))
        XCTAssertTrue(html.contains("<title>\(DiagnosticsReporter.reportTitle)</title>"))
        XCTAssertTrue(html.contains(DiagnosticsReporter.style()))
        XCTAssertTrue(html.contains("</head>"))
    }
}

struct MockedReport: DiagnosticsReporting {
    var diagnostics: Diagnostics = [:]
    func report() -> DiagnosticsChapter {
        return DiagnosticsChapter(title: UUID().uuidString, diagnostics: diagnostics)
    }
}

struct MockedFilter: DiagnosticsReportFilter {
    static func filter(_ diagnostics: Diagnostics) -> Diagnostics {
        return "FILTERED"
    }
}
