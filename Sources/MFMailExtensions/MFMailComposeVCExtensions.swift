//
//  MFMailComposeVCExtensions.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation
import MessageUI

public extension MFMailComposeViewController {

    func addDiagnosticReport(_ report: DiagnosticsReport) {
        addAttachmentData(report.data, mimeType: report.mimeType.rawValue, fileName: report.filename)
    }

}
