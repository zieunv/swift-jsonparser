//
//  JSONString.swift
//  JSONParser
//
//  Created by 이동건 on 09/08/2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

struct JSONString {
    private var value: String
    var isValid: Bool {
        return !isNested && !isPairInArray && isValidBracketPairs
    }
    
    private var isNested: Bool {
        if let regex = try? NSRegularExpression(pattern: "\\{(?:.+?)?(?:\\{|\\[)(?:.+?)?(?:\\}|\\])(?:.+?)?\\}", options: .caseInsensitive) {
            let string = value as NSString
            return !regex.matches(in: value, options: [], range: NSRange(location: 0, length: string.length)).isEmpty
        }
        return false
    }
    
    private var isPairInArray: Bool {
        if let regex = try? NSRegularExpression(pattern: "\\[[a-z0-9\"\\s]+:[a-z0-9\"\\s]+\\]", options: .caseInsensitive) {
            let string = value as NSString
            return !regex.matches(in: value, options: [], range: NSRange(location: 0, length: string.length)).isEmpty
        }
        
        return false
    }
    
    private var isValidBracketPairs: Bool {
        let onlyData = value.filter {$0 != Character("{") && $0 != Character("}") && $0 != Character("[") && $0 != Character("]")}
        let brackets = value.filter { !onlyData.contains($0)}
        var bracketStack: [Character] = []
        for bracket in brackets {
            if bracket == Character("{") || bracket == Character("[") {
                bracketStack.append(bracket)
            }else {
                if bracketStack.isEmpty {
                    return false
                }
                let top = bracketStack.last
                if (top == "{" && bracket == "}") || (top == "[" && bracket == "]") {
                    bracketStack.removeLast()
                }
            }
        }
        
        return bracketStack.count == 0
    }
    
    init(_ value: String) {
        self.value = value
    }
}
