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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sendDiagnostics(_ sender: UIButton) {
        let reporter = DiagnosticsReporter()
        let reportGenerator = DiagnosticReportGenerator(reporter: reporter)
        let report = reportGenerator.generate()

        let path = "/Users/antoinevanderlee/Desktop/Diagnostics/\(report.filename)"
        FileManager.default.createFile(atPath: path, contents: report.data, attributes: [FileAttributeKey.type: report.mimeType.rawValue])

        guard MFMailComposeViewController.canSendMail() else { return }

        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["someone@example.com"])
        mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
        mail.addDiagnosticReport(report)

        present(mail, animated: true)
    }

}

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
