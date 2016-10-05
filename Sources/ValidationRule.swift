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
    let type:ValidationType
    let message:String
    let pattern:String?
    let block:ValidationBlock?
    
    public init(name:String, type:ValidationType, message:String, pattern:String? = nil, block:ValidationBlock? = nil) {
        self.name       = name
        self.type       = type
        self.message    = message
        self.pattern    = pattern
        self.block      = block
    }
}

/// Validation rule for Email
public let Email        = DefaultValidatorPattern.email.rule

/// Validation rule for URL
public let URL          = DefaultValidatorPattern.url.rule

/// Validation rule for only letters and numbers.
public let AlphaNumeric = DefaultValidatorPattern.alphaNumeric.rule

/// Validation rule for letters only
public let Alpha        = DefaultValidatorPattern.alpha.rule

/// Validation rule for numbers only
public let Numeric      = DefaultValidatorPattern.numeric.rule

/// Validation rule for required fields.
public let Required     = ValidationRule(name: "required", type: .required, message: "Field is required", pattern: nil) { value -> Bool in
    guard let value = value as? String else {
        return false
    }

    return value.characters.count > 0
}

/**
 ## ValidationType
 Defines a category that a validation rule falls under.
 */
public enum ValidationType : RawRepresentable {
    public typealias RawValue = String
    
    case required
    case formatting
    case length
    case custom(String)
    
    public init?(rawValue: ValidationType.RawValue) {
        switch rawValue {
            case "required":   self = .required
            case "formatting": self = .formatting
            case "length":     self = .length
            default: self =    .custom(rawValue)
        }
    }
    
    public var rawValue:RawValue {
        switch self {
            case .required:        return "required"
            case .formatting:      return "formatting"
            case .length:          return "length"
            case .custom(let str): return str
        }
    }
}
