//
//  SmartInsightsReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 09/02/2022.
//  Copyright © 2019 WeTransfer. All rights reserved.
//
import Foundation

public enum InsightResult {
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

public protocol SmartInsight {
    var name: String { get }
    var result: InsightResult { get }
}

/// Reports smart insights based on given variables.
public struct SmartInsightsReporter: DiagnosticsReporting {

    static let title: String = "Smart Insights"
    static var diagnostics: [String: String] {
        let insights: [SmartInsight?] = [
            DeviceStorageInsight(),
            UpdateAvailableInsight()
        ]
        
        let metadata: [String: String] = insights.compactMap { $0 }.reduce([:]) { metadata, insight in
            var metadata = metadata
            metadata[insight.name] = insight.result.message
            return metadata
        }
        return metadata
    }

    public static func report() -> DiagnosticsChapter {
        return DiagnosticsChapter(title: title, diagnostics: diagnostics)
    }
}
