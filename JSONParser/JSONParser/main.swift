//
//  main.swift
//  JSONParser
//
//  Created by JK on 10/10/2017.
//  Copyright © 2017 JK. All rights reserved.
//

import Foundation

func main(){
    do {
        let input = try InputView.ask(for: .request)
        guard GrammarChecker.isValid(input) else {
            return
        }
        var jsonTokenizer =  JSONTokenizer.init()
        let tokens = try jsonTokenizer.tokenize(data: input)
        var parser = JSONParser(tokens: tokens)
        let jsonData = try parser.parse()
        try OutputView.printOut(jsonData)
        if let json = jsonData as? JSONSerializable & JSONDataType {
        try OutputView.printJSON(json)
        }
    } catch {
        print(error.localizedDescription)
    }
}

main()



