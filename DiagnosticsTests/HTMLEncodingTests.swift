//
//  HTMLEncodingTests.swift
//  DiagnosticsTests
//
//  Created by David Steppenbeck on 2020/03/16.
//  Copyright © 2020 WeTransfer. All rights reserved.
//

import XCTest
@testable import Diagnostics

final class HTMLEncodingTests: XCTestCase {

    /// It should correctly transform a String to HTML.
    func testAddingHTMLEncoding() {
        let value = "<CONTENT>"
        let expectedHTML = "&lt;CONTENT&gt;"
        XCTAssertEqual(value.addingHTMLEncoding(), expectedHTML)
    }

}
