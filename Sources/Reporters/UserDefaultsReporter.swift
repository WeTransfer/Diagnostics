//
//  UserDefaultsReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

/// Generates a report from all the registered UserDefault keys.
struct UserDefaultsReporter: DiagnosticsReporting {

    static func report() -> DiagnosticsChapter {
        let formattedDictionary = UserDefaults.standard.jsonRepresentation
        return DiagnosticsChapter(title: "UserDefaults", diagnostics: "<pre>\(formattedDictionary ?? "User Defaults could not be parsed")</pre>")
    }
}

private extension UserDefaults {
    var jsonRepresentation: String? {
        let jsonCompatibleDictionary = dictionaryRepresentation().jsonCompatible
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonCompatibleDictionary, options: [.prettyPrinted, .sortedKeys, .fragmentsAllowed]) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

private extension Dictionary where Key == String, Value == Any {
    var jsonCompatible: [String: Any] {
        return mapValues { value -> Any in
            if let dict = value as? [String: Any] {
                return dict.jsonCompatible
            } else if let array = value as? [Any] {
                return array.map { "\($0)" }
            }

            return "\(value)"
        }
    }
}
