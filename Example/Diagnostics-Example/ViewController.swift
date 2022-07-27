//
//  ViewController.swift
//  Diagnostics-Example
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit
import MessageUI
import Diagnostics

final class ViewController: UIViewController {

    @IBAction private func sendDiagnostics(_ sender: UIButton) {
        /// Create the report.
        var reporters = DiagnosticsReporter.DefaultReporter.allReporters
        reporters.insert(CustomReporter(), at: 1)

        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        print(documentsURL)
        reporters.insert(DirectoryTreesReporter(directories: [documentsURL]), at: 2)
        let report = DiagnosticsReporter.create(
            using: reporters,
            filters: [
                DiagnosticsDictionaryFilter.self,
                DiagnosticsStringFilter.self
            ],
            smartInsightsProvider: SmartInsightsProvider()
        )

        guard MFMailComposeViewController.canSendMail() else {
            /// For debugging purposes you can save the report to desktop when testing on the simulator.
            /// This allows you to iterate fast on your report.
            report.saveToDesktop()
            return
        }

        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["support@yourcompany.com"])
        mail.setSubject("Diagnostics Report")
        mail.setMessageBody("An issue in the app is making me crazy, help!", isHTML: false)

        /// Add the Diagnostics Report as an attachment.
        mail.addDiagnosticReport(report)

        present(mail, animated: true)
    }

    @IBAction private func crashTriggerButtonTapped(_ sender: Any) {
        /// Swift exceptions can't be catched yet, unfortunately.
        let array = NSArray(array: ["Antoine", "Boris", "Kaira"])
        print(array.object(at: 4)) // Classic index out of bounds crash
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
