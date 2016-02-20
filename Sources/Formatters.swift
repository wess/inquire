//
//  Formatters.swift
//  Pods
//
//  Created by Wesley Cope on 2/18/16.
//
//

import Foundation

internal func formatString(string:String, pattern:String, mask:String = "#", placeholder:String = "") -> String {
    var result  = pattern
    var current = pattern.startIndex
    
    for index in pattern.characters.indices {
        let char = String(pattern[index])
        let replacement:String
        
        if char == mask {
            if current == string.characters.endIndex {
                replacement = placeholder
            }
            else {
                replacement = String(string[current])
                current = current.successor()
            }
            
            result.replaceRange(index..<index.successor(), with: replacement)
        }
    }
    
    
    return result
}
