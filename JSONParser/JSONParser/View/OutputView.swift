//
//  OutputView.swift
//  JSONParser
//
//  Created by 이희찬 on 03/06/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

struct OutputView {
    
    static func printResult(countNumber:countable) {
        let dataOfString = countNumber.countNumbers.string
        let dataOfInt = countNumber.countNumbers.int
        let dataOfBool = countNumber.countNumbers.bool
        print("총\(dataOfInt + dataOfBool + dataOfString) 개의 데이터 중에 문자열 \(dataOfString)개, 숫자 \(dataOfInt)개, 부울 \(dataOfBool)개가 포함되어 있습니다.")
    }
    
}