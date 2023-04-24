//
//  CellularAllowedInsight.swift
//  
//
//  Created by Antoine van der Lee on 27/07/2022.
//

import CoreTelephony
import Foundation

#if os(iOS) && !targetEnvironment(macCatalyst)
/// Shows an insight on whether the user has enabled cellular data system-wide for this app.
struct CellularAllowedInsight: SmartInsightProviding {

    let name = "Cellular data allowed"
    let result: InsightResult

    init() {
        let cellularData = CTCellularData()
        switch cellularData.restrictedState {
        case .restricted:
            result = .error(message: "The user has disabled cellular data usage for this app.")
        case .notRestricted:
            result = .success(message: "Cellular data is enabled for this app.")
        default:
            result = .warn(message: "Unable to determine whether cellular data is allowed for this app.")
        }
    }
}
#endif
