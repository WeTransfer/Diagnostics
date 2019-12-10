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
    typealias DiagnosticsType = KeyValuePairs<String, String>

    // Filter out the key with the value "App Display Name"
    // This demonstrates how a filter can be used to filter out sensible data.
    static func filter(_ diagnostics: KeyValuePairs<String, String>) -> KeyValuePairs<String, String> {
        let filteredKeyValuePairs: (String, String) = diagnostics.filter { (keyValue) -> Bool in
            return keyValue.key != "App Display Name"
        }.map { ($0.key, $0.value) }
        return KeyValuePairs<String, String>(dictionaryLiteral: filteredKeyValuePairs)
    }
}
