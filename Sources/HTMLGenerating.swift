//
//  HTMLGenerating.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public typealias HTML = String

public protocol HTMLGenerating {
    func html() -> HTML
}

extension Dictionary: HTMLGenerating where Key == String, Value == String {
    public func html() -> HTML {
        var html = "<ul>"

        for (key, value) in self {
            html += "<li><b>\(key)</b> \(value)</li>"
        }

        html += "</ul>"

        return html
    }
}

extension KeyValuePairs: HTMLGenerating where Key == String, Value == String {
    public func html() -> HTML {
        var html = "<ul>"

        for (key, value) in self {
            html += "<li><b>\(key)</b> \(value)</li>"
        }

        html += "</ul>"

        return html
    }
}

extension String: HTMLGenerating {
    public func html() -> HTML {
        return self//.replacingOccurrences(of: "\n", with: "<br/>")
    }
}

extension DiagnosticsChapter: HTMLGenerating {
    public func html() -> HTML {
        var html = "<div class=\"chapter\"><h3>\(title)</h3>"
        html += "<div class=\"chapter-content\">\(diagnostics.html())</div>"
        html += "</div>"
        return html
    }
}
