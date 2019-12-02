//
//  AppMetadataReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

struct AppMetadataReporter: DiagnosticsReporting {

    static var title: String = "App Details"
    static var diagnostics: Diagnostics {
        return ["App name": Bundle.appName].compactMapValues { $0 }
    }

    static func report() -> DiagnosticsChapter {
        return DiagnosticsChapter(title: title, diagnostics: diagnostics)
    }
}
