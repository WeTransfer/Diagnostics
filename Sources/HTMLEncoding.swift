//
//  HTMLEncoding.swift
//  Diagnostics
//
//  Created by David Steppenbeck on 2020/02/26.
//  Copyright © 2020 WeTransfer. All rights reserved.
//

import Foundation

public protocol HTMLEncoding {
    func addingHTMLEncoding() -> HTML
}

extension String: HTMLEncoding {
    
    /// Encodes entities to be displayed correctly in the final HTML report.
    func addingHTMLEncoding() -> HTML {
        return self.replacingOccurrences(of: "<", with: "&lt;")
                   .replacingOccurrences(of: ">", with: "&gt;")
    }
}
