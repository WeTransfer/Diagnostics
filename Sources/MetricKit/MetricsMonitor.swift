//
//  MetricsMonitor.swift
//  
//
//  Created by Antoine van der Lee on 31/08/2021.
//

import Foundation
import MetricKit

/// Monitors payloads delivered by MetricKit and logs valueable information, including crashes.
final class MetricsMonitor: NSObject {
    
    func startMonitoring() {
        if #available(iOS 14, *) {
            MXMetricManager.shared.add(self)
        }
        
        NSSetUncaughtExceptionHandler { exception in
            MetricsMonitor.logExceptionUsingCallStackSymbols(exception, description: "Uncaught Exception")
        }
    }
    
    /// Creates a new log section with the current thread call stack symbols.
    private static func logExceptionUsingCallStackSymbols(_ exception: NSException, description: String) {
        let message = """

        ---

        🚨 CRASH:
        Description: \(description)
        Exception name: \(exception.name.rawValue)
        Reason: \(exception.reason ?? "nil")

            \(Thread.callStackSymbols.joined(separator: "\n"))

        ---

        """
        DiagnosticsLogger.standard.log(message)
    }
}

extension MetricsMonitor: MXMetricManagerSubscriber {
    @available(iOS 13.0, *)
    func didReceive(_ payloads: [MXMetricPayload]) {
        // We don't do anything with metrics yet.
    }
    
    @available(iOS 14.0, *)
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        guard let payload = payloads.last else {
            // We only use the last payload to prevent duplicate logging as much as possible.
            return
        }
        
        let message = """
            
            ---
            MXDIAGNOSTICS RECEIVED:
            \(payload.logDescription)
            ---
            
            """
        DiagnosticsLogger.standard.log(message)
    }
}

@available(iOS 14.0, *)
extension MXDiagnosticPayload {
    var logDescription: String {
        var logs: [String] = []
        logs.append(contentsOf: crashDiagnostics?.compactMap { $0.logDescription } ?? [])
        return logs.joined(separator: "\n")
    }
}

@available(iOS 14.0, *)
extension MXCrashDiagnostic {
    var logDescription: String {
        "💥 Reason: \(terminationReason ?? ""), Type: \(exceptionType?.stringValue ?? ""), Code: \(exceptionCode?.stringValue ?? ""), Signal: \(signal?.stringValue ?? ""), OS: \(metaData.osVersion), Build: \(metaData.applicationBuildVersion)"
    }
}
