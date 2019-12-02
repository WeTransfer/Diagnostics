//
//  GeneralInfoReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

open class GeneralInfoReporter: DiagnosticsReporting {
    open class var title: String {
        return "\(Bundle.appName) - Diagnostics Report"
    }

    open class var description: HTML {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())

        return """
        <p>This diagnostics report can help our Support team to solve the issues you're experiencing. It includes information about your device, settings, logs, and specific user data that allows our engineers to find out what's going on.</p>

        <p>This report was generated on <i>\(dateString) GMT+0</i></p>
        """
    }

    public static func report() -> DiagnosticsChapter {
        return DiagnosticsChapter(title: title, diagnostics: description)
    }
}
