//
//  TypeDictionary.swift
//  JSONParser
//
//  Created by jang gukjin on 09/05/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

struct TypeDictionary: Json {
    private(set) var json : [String:String]
    
    init (json: String) {
        self.json = [String:String]()
        var data = json
        data.removeFirst()
        data.removeLast()
        let dictionaryData = data.components(separatedBy: ",")
        for index in 0...dictionaryData.count - 1 {
            let Values = dictionaryData[index]
            let keyAndValue = Values.components(separatedBy: ":")
            self.json[keyAndValue[0]] = keyAndValue[1]
        }
    }
    
    func countType(jsonDatum: Json) -> String{
        let DictionaryMent = "객체 "
        if (jsonDatum as? TypeDictionary) != nil { return DictionaryMent }
        else { return "" }
    }
}
