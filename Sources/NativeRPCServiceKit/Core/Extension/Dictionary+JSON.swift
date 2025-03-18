//
//  Dictionary+JSON.swift
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2025/1/13.
//

import Foundation

extension Dictionary {
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
}
