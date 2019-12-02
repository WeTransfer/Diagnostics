//
//  DiagnosticsReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public protocol DiagnosticsReporting {
    static func report() -> DiagnosticsChapter
}

public struct DiagnosticsChapter {
    public let title: String
    public let diagnostics: Diagnostics
}

public final class DiagnosticsReporter {

    public enum DefaultReporter: CaseIterable {
        case generalInfo
        case appMetadata
        case logs
        case userDefaults

        var reporter: DiagnosticsReporting.Type {
            switch self {
            case .generalInfo:
                return GeneralInfoReporter.self
            case .appMetadata:
                return AppMetadataReporter.self
            case .logs:
                return LogsReporter.self
            case .userDefaults:
                return UserDefaultsReporter.self
            }
        }

        public static var allReporters: [DiagnosticsReporting.Type] {
            allCases.map { $0.reporter }
        }
    }

    let reporters: [DiagnosticsReporting.Type]

    public init(reporters: [DiagnosticsReporting.Type] = DefaultReporter.allReporters) {
        self.reporters = reporters
    }
}
