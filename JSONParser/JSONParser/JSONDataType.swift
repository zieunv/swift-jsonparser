//
//  JSONToken.swift
//  JSONParser
//
//  Created by JieunKim on 30/05/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

protocol JSONDataType: JSONSerializable {
    var typeDescription: String { get }
}

protocol JSONSerializable {
    func serialize() -> String
}

extension String: JSONDataType {
    var typeDescription: String {
        return "문자열"
    }
    
    func serialize() -> String {
        return "\"\(self)\""
    }
}

typealias Number = Double
extension Number: JSONDataType {
    var typeDescription: String {
        return "숫자"
    }
    
    func serialize() -> String {
        return "\(self)"
    }
    
}

extension Bool: JSONDataType {
    var typeDescription: String {
        return "부울"
    }
    
    func serialize() -> String {
        return "\(self)"
    }
}

protocol TypeCountable {
    var dataTypes: [String: Int] { get }
}

extension Array: JSONSerializable where Element == JSONDataType {
    func serialize() -> String {
        var jsonString = ""
        var first = true
        let indent = String(repeating: " ", count: 2)
        
        jsonString.append("[")
        for value in self {
            if first {
                first = false
            } else {
                jsonString.append(",")
            }
            jsonString.append("\n")
            jsonString.append(indent)
            jsonString.append(value.serialize().replacingOccurrences(of: "\n", with: "\n\(indent)"))
            
        }
        jsonString.append("\n")
        jsonString.append("]")
        return jsonString
    }
}

extension Array: JSONDataType, TypeCountable where Element == JSONDataType {
    
    var typeDescription: String {
        return "배열"
    }
    
    var dataTypes: [String: Int] {
        var dataTypes = [String: Int]()
        for item in self {
            dataTypes[item.typeDescription] = (dataTypes[item.typeDescription] ?? 0) + 1
        }
        return dataTypes
    }
}

typealias Object = Dictionary
extension Dictionary: JSONSerializable where Key == String, Value == JSONDataType {
    func serialize() -> String {
        var jsonString = ""
        var first = true
        let indent = String(repeating: " ", count: 2)
        
        jsonString.append("{")
        jsonString.append("\n")
        for (key, value) in self {
            if first {
                first = false
            } else {
                jsonString.append(",\n")
            }
            jsonString.append(indent)
            jsonString.append("\(key)")
            jsonString.append(":")
            jsonString.append(" ")
            
            jsonString.append(value.serialize().replacingOccurrences(of: "\n", with: "\n\(indent)"))
        }
        jsonString.append("\n")
        jsonString.append("}")
        return jsonString
    }
}

extension Object: JSONDataType, TypeCountable where Key == String, Value == JSONDataType {
    var typeDescription: String {
        return "객체"
    }
    var dataTypes: [String: Int] {
        var dataTypes = [String: Int]()
        for item in self.values {
            dataTypes[item.typeDescription] = (dataTypes[item.typeDescription] ?? 0) + 1
        }
        return dataTypes
    }
    
    
}
