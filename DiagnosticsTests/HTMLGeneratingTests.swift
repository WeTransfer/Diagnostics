//
//  HTMLGeneratingTests.swift
//  DiagnosticsTests
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import XCTest
@testable import Diagnostics

final class HTMLGeneratingTests: XCTestCase {

    /// It should generate HTML for diagnostic chapters correctly.
    func testDiagnosticsChapterHTML() {
        let chapter = DiagnosticsChapter(title: "TITLE", diagnostics: "CONTENT")
        let expectedHTML = "<div class=\"chapter\"><span class=\"anchor\" id=\"\(chapter.title.lowercased())\"></span><h3>\(chapter.title)</h3><div class=\"chapter-content\">\(chapter.diagnostics.html())</div></div>"
        XCTAssertEqual(chapter.html(), expectedHTML)
    }

    /// It should correctly transform a Dictionary to HTML.
    func testDictionaryHTML() {
        let dict = ["App Name": "Collect by WeTransfer"]
        let expectedHTML = "<ul><li><b>\(dict.keys.first!)</b> \(dict.values.first!)</li></ul>"
        XCTAssertEqual(dict.html(), expectedHTML)
    }

    /// It should correctly transform a Dictionary to HTML.
    func testKeyValuePairsHTML() {
        let dict: KeyValuePairs<String, String> = ["App Name": "Collect by WeTransfer"]
        let expectedHTML = "<table><tr><th>\(dict.first!.key)</th><td>\(dict.first!.value)</td></tr></table>"
        XCTAssertEqual(dict.html(), expectedHTML)
    }

    /// It should correctly transform a String to HTML.
    func testStringHTML() {
        let value = "CONTENT"
        let expectedHTML = "CONTENT"
        XCTAssertEqual(value.html(), expectedHTML)
    }

}
