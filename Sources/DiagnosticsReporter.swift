//
//  DiagnosticsReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public protocol DiagnosticsReportable {

}

public final class DiagnosticsReporter {

    private var reporters: [DiagnosticsReportable] = []

    public func add(_ reporter: DiagnosticsReportable) {
        reporters.append(reporter)
    }




}
