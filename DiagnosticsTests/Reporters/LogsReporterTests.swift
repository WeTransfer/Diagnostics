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
    func testMessagesLog() {
        let message = UUID().uuidString
        DiagnosticsLogger.log(message: message)
        let diagnostics = LogsReporter.report().diagnostics as! String
        XCTAssertTrue(diagnostics.contains(message), "Diagnostics is \(diagnostics)")
    }

    /// It should show errors.
    func testErrorLog() {
        enum Error: Swift.Error {
            case testCase
        }

        DiagnosticsLogger.log(error: Error.testCase)
        let diagnostics = LogsReporter.report().diagnostics as! String
        XCTAssertTrue(diagnostics.contains("testCase"))
    }

    /// It should reverse the order of sessions to have the most recent session on top.
    func testReverseSessions() throws {
        DiagnosticsLogger.log(message: "first")
        DiagnosticsLogger.standard.startNewSession()
        DiagnosticsLogger.log(message: "second")
        let diagnostics = LogsReporter.report().diagnostics as! String
        let firstIndex = try XCTUnwrap(diagnostics.range(of: "first")?.lowerBound)
        let secondIndex = try XCTUnwrap(diagnostics.range(of: "second")?.lowerBound)
        XCTAssertTrue(firstIndex > secondIndex)
    }

}
