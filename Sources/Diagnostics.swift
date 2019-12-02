//
//  Diagnostics.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public protocol Diagnostics: HTMLGenerating { }
extension KeyValuePairs: Diagnostics where Key == String, Value == String { }
extension String: Diagnostics { }
