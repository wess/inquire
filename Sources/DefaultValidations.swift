//
//  DefaultValidations.swift
//  Inquire
//
//  Created by Wesley Cope on 2/12/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation

internal enum DefaultValidatorPattern {
    case Email
    case URL
    case AlphaNumeric
    case Alpha
    case Numeric

    var pattern:String? {
        switch self {
        case .Email:
            return "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            
        case .URL:
            return "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
            
        case .AlphaNumeric:
            return "[^0-9a-zA-Z]"
            
        case .Alpha:
            return "[^a-zA-Z]"
            
        case .Numeric:
            return "[^0-9]"
        }
    }
    
    var stringValue:String {
        switch self {
        case .Email:
            return "email"
            
        case .URL:
            return "url"
            
        case .AlphaNumeric:
            return "alpha_numeric"
            
        case .Alpha:
            return "alpha"
            
        case .Numeric:
            return "numeric"
        }
    }
    
    var message:String {
        switch self {
        case .Email:
            return "Invalid email address"
            
        case .URL:
            return "Invalid URL"
            
        case .AlphaNumeric:
            return "{field} can only be letters and numbers"
            
        case .Alpha:
            return "{field} can only be letters"
            
        case .Numeric:
            return "{field} can only be numbers"
        }
    }
    
    var type:ValidationType {
        switch self {
        case .Email, .URL, .AlphaNumeric, .Alpha, .Numeric:
            return ValidationType.Formatting
        }
    }

        
    var rule:ValidationRule {
        return ValidationRule(name: stringValue, type: type, message: message, pattern: pattern, block: nil)
    }

}




