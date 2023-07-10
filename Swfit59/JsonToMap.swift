//
//  JsonToMap.swift
//  Swfit59
//
//  Created by chengbin on 2023/7/27.
//

import Foundation

extension String {
    var toMap: [String: Any] {
        let data = Data(self.utf8)
        do {
            // make sure this JSON is in the format we expect
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                return dictionary
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return [:]
    }
}

extension Data {
    var toMap: [String: Any] {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) {
            return json as! [String: Any]
        }

        return [:]
    }

    var toJson: String {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) {
            if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                return String(bytes: prettyPrintedData, encoding: String.Encoding.utf8) ?? "NIL"
            }
        }
        return ""
    }
}
