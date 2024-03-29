//
//  ViewController.swift
//  Diagnostics-Example
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Diagnostics
import MessageUI
import UIKit

final class ViewController: UIViewController {

    @IBAction private func sendDiagnostics(_ sender: UIButton) {
        /// Create the report.
        var reporters = DiagnosticsReporter.DefaultReporter.allReporters
        reporters.insert(CustomReporter(), at: 1)

        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let directoryTreesReporter = DirectoryTreesReporter(
            trunks: [
                Directory(url: documentsURL)
            ]
        )
        reporters.insert(directoryTreesReporter, at: 2)

        let report = DiagnosticsReporter.create(
            using: reporters,
            filters: [
                DiagnosticsDictionaryFilter.self,
                DiagnosticsStringFilter.self
            ],
            smartInsightsProvider: SmartInsightsProvider()
        )

        guard MFMailComposeViewController.canSendMail() else {
            #if targetEnvironment(simulator)
                /// For debugging purposes you can save the report to desktop when testing on the simulator.
                /// This allows you to iterate fast on your report.
                report.saveToDesktop()
            #else
                presentShareExtension(for: report)
            #endif
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

    private func presentShareExtension(for report: DiagnosticsReport) {
        let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent(report.filename)
        try! report.data.write(to: destinationURL)
        let activityViewController = UIActivityViewController(
            activityItems: [
                destinationURL
            ].compactMap { $0 },
            applicationActivities: nil
        )

        present(activityViewController, animated: true, completion: nil)
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
