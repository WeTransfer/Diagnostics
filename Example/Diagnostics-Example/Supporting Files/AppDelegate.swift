//
//  AppDelegate.swift
//  Diagnostics-Example
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit
import Diagnostics

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    enum ExampleError: Error {
        case missingData
    }

    enum ExampleLocalizedError: LocalizedError {
        case missingLocalizedData

        var localizedDescription: String {
            return "Missing localized data"
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            try DiagnosticsLogger.setup()
        } catch {
            print("Failed to setup the Diagnostics Logger")
        }

        DiagnosticsLogger.log(message: "Application started")
        DiagnosticsLogger.log(message: "Log <a href=\"https://www.wetransfer.com\">HTML</a>")
        DiagnosticsLogger.log(error: ExampleError.missingData)
        DiagnosticsLogger.log(error: ExampleLocalizedError.missingLocalizedData)
        DiagnosticsLogger.log(message: "A very long string: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque condimentum facilisis arcu, at fermentum diam fermentum in. Nullam lectus libero, tincidunt et risus vel, feugiat vulputate nunc. Nunc malesuada congue risus fringilla lacinia. Aliquam suscipit nulla nec faucibus mattis. Suspendisse quam nunc, interdum vel dapibus in, vulputate ac enim. Morbi placerat commodo leo, nec condimentum eros dictum sit amet. Vivamus maximus neque in dui rutrum, vel consectetur metus mollis. Nulla ultricies sodales viverra. Etiam ut velit consectetur, consectetur turpis eu, volutpat purus. Maecenas vitae consectetur tortor, at eleifend lacus. Nullam sed augue vel purus mollis sagittis at sed dui. Quisque faucibus fermentum lectus eget porttitor. Phasellus efficitur aliquet lobortis. Suspendisse at lectus imperdiet, sollicitudin arcu non, interdum diam. Sed ornare ante dolor. In pretium auctor sem, id vestibulum sem molestie in.")
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
