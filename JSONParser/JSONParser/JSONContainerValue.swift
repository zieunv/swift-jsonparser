//
//  JSONValueContainable.swift
//  JSONParser
//
//  Created by BLU on 2019. 6. 6..
//  Copyright © 2019년 JK. All rights reserved.
//

import Foundation

protocol JSONContainerValue {
    var containerDescription: String { get }
}

extension Array: JSONValue, JSONContainerValue where Element == JSONValue {
    var typeDescription: String {
        return "배열"
    }
    var containerDescription: String {
        let groupedJSONValues = Dictionary(grouping: self, by: { $0.typeDescription })
        return "총 \(self.count)개의 데이터 중에 \(groupedJSONValues.map { "\($0) \($1.count)개" }.joined(separator: ","))가 포함되어 있습니다."
    }
}