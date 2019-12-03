//
//  Mocks.swift
//  DiagnosticsTests
//
//  Created by Antoine van der Lee on 03/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Diagnostics

struct MockedReporter: DiagnosticsReporting {

    static var diagnosticsChapter: DiagnosticsChapter!

    static func report() -> DiagnosticsChapter {
        return diagnosticsChapter
    }
}
