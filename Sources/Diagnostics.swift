//
//  Diagnostics.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

/// Defines supported `Diagnostics` to generate a report from.
public protocol Diagnostics: HTMLGenerating { }
extension Dictionary: Diagnostics where Key == String { }
extension KeyValuePairs: Diagnostics where Key == String, Value == String { }
extension String: Diagnostics { }
extension DirectoryTreeNode: Diagnostics { }

final class DiagnosticsImp {
    static let resourceBundle: Bundle = {
        let bundle = Bundle(for: DiagnosticsImp.self)

        guard let resourceBundleURL = bundle.url(
            forResource: "Diagnostics", withExtension: "bundle")
            else { fatalError("Diagnostics.bundle not found!") }

        guard let resourceBundle = Bundle(url: resourceBundleURL)
            else { fatalError("Cannot access MySDK.bundle!") }

        return resourceBundle
    }()
}
