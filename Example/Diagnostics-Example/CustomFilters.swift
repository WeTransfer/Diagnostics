//
//  CustomFilter.swift
//  Diagnostics-Example
//
//  Created by Antoine van der Lee on 10/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation
import Diagnostics

struct DiagnosticsDictionaryFilter: DiagnosticsReportFilter {
    typealias DiagnosticsType = [String: String]

    // Filter out the key with the value "App Display Name"
    // This demonstrates how a filter can be used to filter out sensible data.
    static func filter(_ diagnostics: [String: String]) -> [String: String] {
        return diagnostics.filter { keyValue -> Bool in
            return keyValue.key != "App Display Name"
        }
    }
}
