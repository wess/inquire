//
//  Field.swift
//  Inquire
//
//  Created by Wesley Cope on 1/13/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

/// Block used to validate a field's value
public typealias FieldValidationHandler = (Field, AnyObject) -> Void

/// Block called when a field isn't valid
public typealias FieldErrorHandler      = (field:Field, rule:ValidationRule) -> Void

/// Protocol for creating Inquire forms.
public protocol Field {
    // Basic Field properties for UITextField and UITextView
    var frame:CGRect                    {get set}
    var font:UIFont?                    {get set}
    var textColor:UIColor?              {get set}
    var textAlignment: NSTextAlignment  {get set}
    var keyboardType:UIKeyboardType     {get set}
    
    // Additional
    var form:Form?                  {get set}
    var previous:Field?             {get set}
    var next:Field?                 {get set}
    var name:String                 {get set}
    var errors:[String]             {get set}
    var validators:[ValidationRule] {get set}
    var value:String?               {get set}
    var onError:FieldErrorHandler?  {get set}

    mutating func validate() -> Bool
    func isFirstResponder() -> Bool 
}

extension Field {
    public mutating func validate() -> Bool {
        var isValid = true
        
        let validation:Validation
        if let form = self.form {
            validation = form.validation
        }
        else {
            validation = GlobalValidation
        }
            
        for validator in validators {
            isValid = validation.validate(value, rule: validator)
            
            if !isValid {
                errors.append(validator.message)
                
                self.onError?(field: self, rule: validator)
            }
        }

        return isValid
    }
}


