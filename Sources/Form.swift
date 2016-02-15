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
 # Form
 Subclass to create a new form that defines fields and their validators.
 */
public class Form : NSObject {
    /// Validation instance used for validating form fields.
    public let validation = Validation()
    
    /// The Current field of the form that has focus.
    public var currentField:Field?
    
    /// Form errors from field validations
    public var errors:[String:[String]] = [:]
    
    /// List of form's fields.
    public var fields:[Field] {
        let orderedFields       = order()
        var fieldsArray:[Field] = []

        for var field in orderedFields {
            fieldsArray.append(field)

            let next        = fieldsArray.count
            let index       = next  - 1
            let previous    = index - 1
            
            field.next      = next      < orderedFields.count   ? orderedFields[next]       : nil
            field.previous  = previous  > 0                     ? orderedFields[previous]   : nil
            field.form      = self
            field.name      = getFieldName(field)
        }
        
        return fieldsArray
    }
    
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
    
    internal func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.filter { $0.label != nil }.map { $0.label! }
    }
}
