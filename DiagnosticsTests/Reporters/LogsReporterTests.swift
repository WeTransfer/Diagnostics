//
//  LogsReporterTests.swift
//  DiagnosticsTests
//
//  Created by Antoine van der Lee on 03/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import XCTest
@testable import Diagnostics

final class LogsReporterTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        try DiagnosticsLogger.setup()
    }

    override func tearDownWithError() throws {
        try DiagnosticsLogger.standard.deleteLogs()
        try super.tearDownWithError()
    }

    /// It should show logged messages.
    func testMessagesLog() throws {
        let message = UUID().uuidString
        DiagnosticsLogger.log(message: message)
        let diagnostics = LogsReporter().report().diagnostics as! String
        XCTAssertTrue(diagnostics.contains(message), "Diagnostics is \(diagnostics)")
        XCTAssertEqual(diagnostics.debugLogs.count, 1)
        let debugLog = try XCTUnwrap(diagnostics.debugLogs.first)
        XCTAssertTrue(debugLog.contains("<span class=\"log-prefix\">LogsReporterTests.swift:L27</span>"), "Prefix should be added")
        XCTAssertTrue(debugLog.contains("<span class=\"log-message\">\(message)</span>"), "Log message should be added")
    }

    /// It should show errors.
    func testErrorLog() throws {
        enum Error: Swift.Error {
            case testCase
        }

        DiagnosticsLogger.log(error: Error.testCase)
        let diagnostics = LogsReporter().report().diagnostics as! String
        XCTAssertTrue(diagnostics.contains("testCase"))
        XCTAssertEqual(diagnostics.errorLogs.count, 1)
        let errorLog = try XCTUnwrap(diagnostics.errorLogs.first)
        XCTAssertTrue(errorLog.contains("<span class=\"log-message\">ERROR: testCase"))
    }

    /// It should reverse the order of sessions to have the most recent session on top.
    func testReverseSessions() throws {
        DiagnosticsLogger.log(message: "first")
        DiagnosticsLogger.standard.startNewSession()
        DiagnosticsLogger.log(message: "second")
        let diagnostics = LogsReporter().report().diagnostics as! String
        let firstIndex = try XCTUnwrap(diagnostics.range(of: "first")?.lowerBound)
        let secondIndex = try XCTUnwrap(diagnostics.range(of: "second")?.lowerBound)
        XCTAssertTrue(firstIndex > secondIndex)
    }

}
