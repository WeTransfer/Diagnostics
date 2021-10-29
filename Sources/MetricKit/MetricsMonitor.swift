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
        #if os(iOS)
            if #available(iOS 14, *) {
                MXMetricManager.shared.add(self)
            }
        #endif

        NSSetUncaughtExceptionHandler { exception in
            MetricsMonitor.logExceptionUsingCallStackSymbols(exception, description: "Uncaught Exception")
        }
    }

    /// Creates a new log section with the current thread call stack symbols.
    private static func logExceptionUsingCallStackSymbols(_ exception: NSException, description: String) {
        DiagnosticsLogger.standard.log(ExceptionLog(exception, description: description))
    }
}

#if os(iOS)
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

        DiagnosticsLogger.standard.log(payload)
    }
}
#endif
