//
//  AppMetadataReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

struct AppMetadataReporter: DiagnosticsReporting {

    static var title: String = "App Details"
    static var diagnostics: Diagnostics {
        return ["App name": appDisplayName].compactMapValues { $0 }
    }

    private static let appDisplayName = Bundle.main.infoDictionary?["CFBundleName"] as? String

    static func report() -> DiagnosticsChapter {
        return DiagnosticsChapter(title: title, diagnostics: diagnostics)
    }
}
