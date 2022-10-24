//
//  Data+Ext.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 14.10.2022.
//

import Foundation

extension Data {
    /// NSString gives us a nice sanitized debugDescription
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(
                    with: self,
                    options: []
                ),
              let data = try? JSONSerialization.data(
                    withJSONObject: object,
                    options: [.prettyPrinted]
                ),
              let prettyPrintedString = String(
                    data: data,
                    encoding: .utf8
                )
        else {
            return nil
        }

        return prettyPrintedString
    }
}
