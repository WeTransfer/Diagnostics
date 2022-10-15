//
//  SmartInsightsReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 09/02/2022.
//  Copyright © 2019 WeTransfer. All rights reserved.
//
import Foundation

public enum InsightResult: Equatable {
    case success(message: String)
    case warn(message: String)
    case error(message: String)

    var message: String {
        switch self {
        case .success(let message):
            return "✅ \(message)"
        case .warn(let message):
            return "⚠️ \(message)"
        case .error(let message):
            return "❌ \(message)"
        }
    }
}

/// Provides a smart insights with a given success, error, or warn result.
public protocol SmartInsightProviding {

    /// The name of the smart insight.
    var name: String { get }

    /// The result of this insight, see `InsightResult`.
    var result: InsightResult { get }
}

/// Reports smart insights based on given variables.
public struct SmartInsightsReporter: DiagnosticsReporting {

    let title: String = "Smart Insights"
    var insights: [SmartInsightProviding]

    init(itunesRegion: String = "us") {
        var defaultInsights: [SmartInsightProviding?] = [
            DeviceStorageInsight(),
            UpdateAvailableInsight(itunesRegion: itunesRegion)
        ]
        #if os(iOS) && !targetEnvironment(macCatalyst)
            defaultInsights.append(CellularAllowedInsight())
        #endif
        
        insights = defaultInsights.compactMap { $0 }
    }

    public func report() -> DiagnosticsChapter {
        let diagnostics: [String: String] = insights.compactMap { $0 }.reduce([:]) { metadata, insight in
            var metadata = metadata
            metadata[insight.name] = insight.result.message
            return metadata
        }
        return DiagnosticsChapter(title: title, diagnostics: diagnostics)
    }
}
