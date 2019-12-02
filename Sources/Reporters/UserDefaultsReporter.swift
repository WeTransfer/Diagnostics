//
//  UserDefaultsReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

open class UserDefaultsReporter: DiagnosticsReporting {

    public static func report() -> DiagnosticsChapter {
//        let dictionary = UserDefaults.standard.keyValuePairsRepresentation
        let formattedDictionary = UserDefaults.standard.jsonRepresentation
        return DiagnosticsChapter(title: "UserDefaults", diagnostics: "<pre>\(formattedDictionary!)</pre>")
    }
}

extension Dictionary where Key == String, Value == Any {
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

extension UserDefaults {
    var keyValuePairsRepresentation: [String: Any] {
        dictionaryRepresentation().jsonCompatible
    }

    var jsonRepresentation: String? {
        "\(keyValuePairsRepresentation.format(options: [.prettyPrinted, .sortedKeys, .fragmentsAllowed]) ?? "")"
    }
}

extension Dictionary {
    func format(options: JSONSerialization.WritingOptions) -> Any? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            return try JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments])
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}

extension String {
    init(userDefaults: UserDefaults) {
        var string = ""
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            string += "\(key) = \(value) \n"
        }
        self = string
    }
}
