//
//  JsonParser.swift
//  JSONParser
//
//  Created by joon-ho kil on 4/29/19.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

struct JsonParser {
    static func parseJson (_ input: String) -> JsonType {
        let devideCharacter = DevideCharacter(rawValue: input.first ?? ":") ?? .colon
        let elements: [String]
        
        if devideCharacter == DevideCharacter.squareBracketOpen {
            let elementsFromArray = RegexGrammar.elementsFromArray
            elements = input.matches(for: elementsFromArray.rawValue)
            return JsonType.array(elementsToJson(elements))
        }
        
        return elementToObject(input)
    }
    
    static private func elementsToJson (_ elements: [String]) -> [JsonType] {
        var json = [JsonType]()
        
        for element in elements {
            json.append(elementToJsonType(element))
        }
        
        return json
    }
    
    static private func elementToJsonType (_ element: String) -> JsonType {
        switch element.first {
        case "{": return elementToObject(element)
        case "[": return JsonType.array(elementToArray(element))
        default: return getJsonValue(element)
        }
    }
    
    static private func elementToObject (_ input: String) -> JsonType {
        var jsonObject = [String:JsonType]()
        
        let elementsFromObject = RegexGrammar.elementsFromObject
        let elements = input.matches(for: elementsFromObject.rawValue)
        
        let colon = DevideCharacter.colon
        var elementSplited: [String]
        
        for element in elements {
            elementSplited = element.components(separatedBy: String(colon.rawValue))
            if elementSplited[0].first == " " {
                elementSplited[0].removeFirst()
            }
            elementSplited[0].removeLast()
            elementSplited[1].removeFirst()
            jsonObject[elementSplited[0]] = getJsonValue(elementSplited[1])
        }
        
        return JsonType.object(jsonObject)
    }
    
    static private func elementToArray (_ element: String) -> [JsonType] {
        var jsonArray = [JsonType]()
        let elementsFromArray = RegexGrammar.elementsFromArrayInArray
        let elements = element.matches(for: elementsFromArray.rawValue)
    
        for element in elements {
            jsonArray.append(getJsonValue(element))
        }
        
        return jsonArray
    }
    
    static private func getJsonValue (_ input: String) -> JsonType {
        if input.first == "[" { return JsonType.array(elementToArray(input)) }
        if let number = Int(input) { return JsonType.int(number) }
        else if input == "true" { return JsonType.bool(true) }
        else if input == "false" { return JsonType.bool(false) }
        else { return JsonType.string(input) }
    }
}
