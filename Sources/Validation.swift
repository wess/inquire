//
//  Validation.swift
//  Inquire
//
//  Created by Wesley Cope on 1/14/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation

/// ValidationBlock: Block used to validate string values.
public typealias ValidationBlock = (AnyObject) -> Bool

/**
 # Valdation
 Class used for loading and executing validations for form field values.
 */
open class Validation {
    
    fileprivate func validateWithPattern(_ value:String, pattern:String) -> Bool {
        if value.characters.count < 0 {
            return false
        }
        
        do {
            let regex   = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let matches = regex.matches(in: value, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, value.characters.count))
            
            return matches.count > 0 ? true : false
        }
        catch {
            print("Invalid pattern: \(pattern)")
            return false
        }
    }
    
    /**
     ## Validate
     Takes a value and a rule to use to validate the value and return if it's valid or note.
     - returns: Bool
     - Parameter value:String
     - Parameter rule:ValidationRule
     */
    open func validate(_ value:String?, rule:ValidationRule) -> Bool {
        var isValid = true
        
        guard let text = value else {
            return false
        }
        
        if let block = rule.block {
            isValid = block(text as AnyObject)
        }

        if let pattern = rule.pattern {
            isValid = validateWithPattern(text, pattern: pattern)
        }

        return isValid
    }
}

/// Global validator to use with fields who have no forms.
internal let GlobalValidation:Validation = Validation()
