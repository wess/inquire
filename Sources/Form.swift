//
//  Form.swift
//  Inquire
//
//  Created by Wesley Cope on 1/13/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

/**
 # FormFieldDefaults
 Protocol used if form should define defaults for all fields (these are overwritten by field's setup block).
 */

public protocol FormFieldDefaults {
    var font:UIFont                         {get}
    var textColor:UIColor                   {get}
    var textAlignment:NSTextAlignment       {get}
    var keyboardType:UIKeyboardType         {get}
    var defaultValidation:[ValidationRule]  {get}
}

public extension FormFieldDefaults {
    var font:UIFont {
        return UIFont.systemFontOfSize(UIFont.systemFontSize())
    }
    
    var textColor:UIColor {
        return .blackColor()
    }
    
    var textAlignment:NSTextAlignment {
        return .Left
    }
    
    var keyboardType:UIKeyboardType {
        return .Default
    }
    
    var defaultValidation:[ValidationRule] {
        return []
    }
}

/**
 # Form
 Subclass to create a new form that defines fields and their validators.
 */
public class Form : NSObject {
    /// Validation instance used for validating form fields.
    public let validation = Validation()
    
    /// The Current field of the form that has focus.
    public var currentField:Field? {
        
        for field in fields {
            if field.isFirstResponder() {
                return field
            }
        }
        
        return nil
    }
    
    /// Form errors from field validations
    public var errors:[String:[String]] = [:]
    
    /// List of form's fields.
    public lazy var fields:[Field] = {
        let orderedFields       = self.order()
        var fieldsArray:[Field] = []

        for var field in orderedFields {
            fieldsArray.append(field)

            let next        = fieldsArray.count
            let index       = next  - 1
            let previous    = index - 1
            
            field.next          = next      < orderedFields.count   ? orderedFields[next]       : nil
            field.previous      = previous  > -1                    ? orderedFields[previous]   : nil
            field.form          = self
            field.name          = self.getFieldName(field)
            
            if let _self = self as? FormFieldDefaults {
                field.font          = _self.font
                field.textColor     = _self.textColor
                field.textAlignment = _self.textAlignment   ?? .Left
                field.keyboardType  = _self.keyboardType    ?? .Default
            
                if  field.validators.count == 0 {
                    field.validators = _self.defaultValidation
                }
            }
            
            if let _field = field as? TextView {
                _field.setupBlock?(_field)
            }
                
            else if let _field = field as? TextField, setupBlock = _field.setupBlock {
                setupBlock(_field)
            }
        }
        
        return fieldsArray
    }()
    
    /// Specifies if a form (and it's fields) are valid or not.
    public var isValid:Bool {
        var _isValid = true
        
        for var field in fields {
            _isValid = field.validate()
            
            if !_isValid {
                errors[field.name] = field.errors
            }
        }
        
        return _isValid
    }
    
    /**
     ## Order
     Must be overridden in subclass. Defines what order fields should be in.
     */
    public func order() -> [Field] {
        fatalError("Must be implemented in subclass, return a list of fields to be displayed")
    }
    
    private func getFieldName(field:Field) -> String {
        if let f = field as? NSObject {
            
            for property in propertyNames() {
                guard let prop = valueForKey(property) else {
                    continue
                }
                
                if f.hash == prop.hash {
                    return property
                }
            }
        }
        
        return ""
    }
    
    private func propertyNames() -> [String] {
        var token:dispatch_once_t   = 0
        var names:[String]          = []
        
        dispatch_once(&token) { 
            names = Mirror(reflecting: self).children.filter { $0.label != nil }.map { $0.label! }
        }

        return names
    }
}
