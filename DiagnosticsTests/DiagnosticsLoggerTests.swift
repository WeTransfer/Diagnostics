//
//  DiagnosticsLoggerTests.swift
//
//
//  Created by Ian Dundas on 03/05/2024.
//

import XCTest
@testable import Diagnostics

final class DiagnosticsLoggerTests: XCTestCase {

    func testSetupWithCustomLogFolder() throws {
        let fileManager = FileManager.default
        
        // Create temp directory at random temp location:
        let temporaryFolder = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try fileManager.createDirectory(at: temporaryFolder, withIntermediateDirectories: true, attributes: nil)

        addTeardownBlock {
            try FileManager.default.removeItem(at: temporaryFolder)
        } 

        try DiagnosticsLogger.setup(customLogFolder: temporaryFolder)
        DiagnosticsLogger.log(message: "<b>this is a test</b>")

        XCTAssertTrue(DiagnosticsLogger.isSetUp(), "DiagnosticsLogger should be setup")

        let logFileExists = fileManager.fileExists(atPath: temporaryFolder.appendingPathComponent("diagnostics_log.txt").path(percentEncoded: false))
        XCTAssertTrue(logFileExists, "diagnostics_log.txt should exist in the given directory")

    }
}
