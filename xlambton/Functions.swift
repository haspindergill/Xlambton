

//
//  Functions.swift
//  xlambton
//
//  Copyright © 2018 jagdeep. All rights reserved.
//

import Foundation

class UtilityFunctions {
    
    let alphabets = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
   static let numericCodes = ["S","A","C","E","G","I","K","M","O","Q"]
    
    func primes(n: Int) -> [Int] {
        var numbers = [Int](2 ..< n)
        for i in 0..<n - 2 {
            let prime = numbers[i]
            guard prime > 0 else { continue }
            for multiple in stride(from: 2 * prime - 2, to: n - 2, by: prime){
                numbers[multiple] = 0
            }
        }
        return numbers.filter{ $0 > 0 }
    }
    
    
    static func createCodeforAlphabet(text:String) -> String{
        var code = ""
        let primeNumber = UtilityFunctions().primes(n: 150)
        for char in text{
            if char == Character(" "){
                code += "#"
            }
            for (index,alphabet) in UtilityFunctions().alphabets.enumerated() {
                if char == Character(alphabet){
                    code += String(primeNumber[index])
                }
            }
            for (index,_) in numericCodes.enumerated() {
                if char == Character(String(index)){
                    code += String(numericCodes[index])
                }
            }
        }
        return code
    }
    
    
    static func createCodeforNumeric(text:String)->String{
        var code = ""
        for char in text{
            if char == Character(" "){
                code += "#"
            }
            for (index,_) in numericCodes.enumerated() {
                if char == Character(String(index)){
                    code += String(numericCodes[index])
                }
            }
        }
        return code
    }
}
