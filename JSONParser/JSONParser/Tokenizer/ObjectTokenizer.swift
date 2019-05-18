import Foundation

struct ObjectTokenizer {
    
    enum TokenizingError: Error {
        case cannotDetectBeginOrEndOfObject
        case objectKeyShouldBeOneAndOnly
        case invalidNestedStructure
        case invalidObjectGrammar
        case duplicatedColon
        case bufferIsEmpty
    }
    
    static func tokenize(_ input: String) throws -> [String: String] {
        
        guard input.first == Token.beginObject, input.last == Token.endObject else {
            throw TokenizingError.cannotDetectBeginOrEndOfObject
        }
        var input = input
        input.removeFirst()
        input.removeLast()
        let values = input.trimmingCharacters(in: Token.whitespace)
        
        guard FormatValidator.validateObjectFormat(values) else {
            throw TokenizingError.invalidObjectGrammar
        }
        
        var tokenizedInput = [String: String]()
        var keyBuffer = ""
        var valueBuffer = ""
        var isParsingString = false
        var nestedArrayCount: UInt = 0
        var nestedObjectCount: UInt = 0
        var isParsingKey = true
        
        for character in values {
            if character == Token.quotationMark {
                isParsingString.toggle()
            } else if !isParsingString {
                switch character {
                case Token.endObject:
                    guard nestedObjectCount > 0 else {
                        throw TokenizingError.invalidNestedStructure
                    }
                    nestedObjectCount -= 1
                case Token.beginObject:
                    nestedObjectCount += 1
                case Token.endArray:
                    guard nestedArrayCount > 0 else {
                        throw TokenizingError.invalidNestedStructure
                    }
                    nestedArrayCount -= 1
                case Token.beginArray:
                    nestedArrayCount += 1
                case Token.valueSeparator:
                    guard nestedObjectCount == 0, nestedArrayCount == 0 else {
                        break
                    }
                    try move(fromKeyBuffer: &keyBuffer, valueBuffer: &valueBuffer, to: &tokenizedInput)
                    isParsingKey = true
                    continue
                case Token.nameSeparator:
                    guard isParsingKey else {
                        throw TokenizingError.duplicatedColon
                    }
                    isParsingKey = false
                    continue
                default:
                    break
                }
            }
            if isParsingKey {
                keyBuffer.append(character)
            } else {
                valueBuffer.append(character)
            }
        }
        
        if isParsingKey, tokenizedInput.isEmpty {
            return tokenizedInput
        }
        
        try move(fromKeyBuffer: &keyBuffer, valueBuffer: &valueBuffer, to: &tokenizedInput)
        return tokenizedInput
    }
    
    private static func move(fromKeyBuffer keyBuffer: inout String, valueBuffer: inout String, to result: inout [String: String]) throws {
        guard !keyBuffer.isEmpty, !valueBuffer.isEmpty else {
            throw TokenizingError.bufferIsEmpty
        }
        let key = keyBuffer.trimmingCharacters(in: Token.whitespace)
        let value = valueBuffer.trimmingCharacters(in: Token.whitespace)
        guard result[key] == nil else {
            throw TokenizingError.objectKeyShouldBeOneAndOnly
        }
        result[key] = value
        keyBuffer.removeAll()
        valueBuffer.removeAll()
    }
    
}
