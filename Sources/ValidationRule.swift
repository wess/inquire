//
//  ValidationRule.swift
//  Inquire
//
//  Created by Wesley Cope on 2/12/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation

/**
 ## ValidationRule
 Defines a rule used to validate field values.
 - Parameter name:String
 - Parameter message:String
 - Parameter pattern:String
 - Parameter block:ValidationBlock
 */
public struct ValidationRule {
    let name:String
    let message:String
    let pattern:String?
    let block:ValidationBlock?
    
    public init(name:String, message:String, pattern:String? = nil, block:ValidationBlock? = nil) {
        self.name       = name
        self.message    = message
        self.pattern    = pattern
        self.block      = block
    }
}

/// Validation rule for Email
public let Email        = DefaultValidatorPattern.Email.rule

/// Validation rule for URL
public let URL          = DefaultValidatorPattern.URL.rule

/// Validation rule for only letters and numbers.
public let AlphaNumeric = DefaultValidatorPattern.AlphaNumeric.rule

/// Validation rule for letters only
public let Alpha        = DefaultValidatorPattern.Alpha.rule

/// Validation rule for numbers only
public let Numeric      = DefaultValidatorPattern.Numeric.rule

/// Validation rule for required fields.
public let Required     = ValidationRule(name: "required", message: "Field is required", pattern: nil) { value -> Bool in
    guard let value = value as? String else {
        return false
    }

    return value.characters.count > 0
}
