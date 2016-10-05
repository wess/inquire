//
//  DefaultValidations.swift
//  Inquire
//
//  Created by Wesley Cope on 2/12/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation

internal enum DefaultValidatorPattern {
    case email
    case url
    case alphaNumeric
    case alpha
    case numeric

    var pattern:String? {
        switch self {
        case .email:
            return "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            
        case .url:
            return "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
            
        case .alphaNumeric:
            return "[^0-9a-zA-Z]"
            
        case .alpha:
            return "[^a-zA-Z]"
            
        case .numeric:
            return "[^0-9]"
        }
    }
    
    var stringValue:String {
        switch self {
        case .email:
            return "email"
            
        case .url:
            return "url"
            
        case .alphaNumeric:
            return "alpha_numeric"
            
        case .alpha:
            return "alpha"
            
        case .numeric:
            return "numeric"
        }
    }
    
    var message:String {
        switch self {
        case .email:
            return "Invalid email address"
            
        case .url:
            return "Invalid URL"
            
        case .alphaNumeric:
            return "{field} can only be letters and numbers"
            
        case .alpha:
            return "{field} can only be letters"
            
        case .numeric:
            return "{field} can only be numbers"
        }
    }
    
    var type:ValidationType {
        switch self {
        case .email, .url, .alphaNumeric, .alpha, .numeric:
            return ValidationType.formatting
        }
    }

        
    var rule:ValidationRule {
        return ValidationRule(name: stringValue, type: type, message: message, pattern: pattern, block: nil)
    }

}




