//
//  GeneralInfoReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

open class GeneralInfoReporter: DiagnosticsReporting {
    private static let appDisplayName = Bundle.main.infoDictionary?["CFBundleName"] as? String

    open class var title: String {
        return "\(Bundle.appName) - Diagnostics Report"
    }

    open class var description: HTML {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())

        return """
        <p>This diagnostics report can help our Support team to solve the issues you're experiencing. It includes information about your device, settings, logs, and specific user data that allows our engineers to find out what's going on.</p>

        <p>This report was generated on \(dateString)</p>
        """
    }

    public static func report() -> DiagnosticsChapter {
        return DiagnosticsChapter(title: title, diagnostics: description)
    }
}
