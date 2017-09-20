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
public typealias FieldErrorHandler      = (_ field:Field, _ rule:ValidationRule) -> Void

/// Protocol for creating Inquire forms.
public protocol Field : class {
    
    // Basic Field properties for UITextField and UITextView
    var frame:CGRect                    {get set}
    var font:UIFont?                    {get set}
    var textColor:UIColor?              {get set}
    var textAlignment: NSTextAlignment  {get set}
    var keyboardType:UIKeyboardType     {get set}
    
    // Additional
    var form:Form?                          {get set}
    var previousField:Field?                {get set}
    var nextField:Field?                    {get set}
    var name:String                         {get set}
    var errors:[(ValidationType, String)]   {get set}
    var validators:[ValidationRule]         {get set}
    var value:String?                       {get set}
    var onError:FieldErrorHandler?          {get set} 
    
    // Nice to have
    var meta:[String:AnyObject] {get set}
    
    func validate() -> Bool
    func move(_ to:Field)
}

extension Field {
    public func validate() -> Bool {
        var isValid = true
        
        let validation:Validation
        if let form = self.form {
            validation = form.validation
        }
        else {
            validation = GlobalValidation
        }
        
        errors.removeAll()
        for validator in validators {
            isValid = validation.validate(value, rule: validator)
            
            if !isValid {
                errors.append((validator.type, validator.message))
                
                self.onError?(self, validator)
            }
        }

        return isValid
    }
}
