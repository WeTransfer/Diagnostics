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
    typealias DiagnosticsType = [String: Any]

    // This demonstrates how a filter can be used to filter out sensible data.
    static func filter(_ diagnostics: [String: Any]) -> [String: Any] {
        return diagnostics.filter { keyValue -> Bool in
            if keyValue.key == "App Display Name" {
                // Filter out the key with the value "App Display Name"
                return false
            } else if keyValue.key == "AppleLanguages" {
                // Filter out a user defaults key.
                return false
            }
            return true
        }
    }
}
