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

public typealias Fieldname     = String
public typealias Fieldvalue    = String

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
    public var errors:[String:[(ValidationType, String)]] = [:]
    
    /// List of form's fields.
    public var fields:[Field] {
        var clean:[Field]   = []

        var token:dispatch_once_t = 0
        dispatch_once(&token) {
            let dirty           = self.order()
            for index in 0 ..< dirty.count {
                let current = self.setupField(dirty[index])
                
                let previous    = index - 1
                let next        = index + 1
                
                if previous > -1 {
                    current.previous = self.setupField(dirty[previous])
                }
                
                if next < dirty.count {
                    current.next = self.setupField(dirty[next])
                }
                
                clean.append(current)
            }
        }
    
        return clean
    }
    
    /// Specifies if a form (and it's fields) are valid or not.
    public var isValid:Bool {
        var _isValid = true
        
        errors.removeAll()
        for field in fields {
            _isValid = field.validate()
            
            if !_isValid {
                errors[field.name] = field.errors
            }
        }
        
        return (errors.count == 0)
    }
    
    public lazy var allFields:[Field] = {
        let _allFields = self.buildFieldsArray()
        
        return _allFields
    }()
    
    private var defaults:[Fieldname:Fieldvalue]? = nil
    
    public init(defaults:[Fieldname:Fieldvalue]? = nil) {
        super.init()
        
        self.defaults = defaults
        buildFieldsArray()
    }
    
    /**
     ## Order
     Must be overridden in subclass. Defines what fields and the order they should be in.
     */
    public func order() -> [Field] {
        fatalError("Must be implemented in subclass, return a list of fields to be displayed")
    }
    
    /**
     ## Form as a responder
     By resigning every field in the form as firstResponder, the form resigns first responder :)
    */
    public func resignFirstResponder() {
        let _ = fields.map {
            if let _field = $0 as? TextView {
                _field.resignFirstResponder()
            }
                
            else if let _field = $0 as? TextField {
                _field.resignFirstResponder()
            }

        }
    }
}

private extension Form /* Private */ {
    func buildFieldsArray() -> [Field] {
        var fieldsArray:[Field] = []
        
        var token:dispatch_once_t = 0
        dispatch_once(&token) {
            let orderedFields       = self.order()
            let fields              = self.properties().flatMap { incoming -> Field in
                let field   = self.setupField(incoming.1)
                field.name  = incoming.0
                
                return field
            }
            
            for field in fields {
                let _field = field
                
                if let orderedIndex = orderedFields.indexOf({
                    
                    if let _zero = $0 as? TextField, _field = field as? TextField {
                        return _zero == _field
                    }
                    else if let _zero = $0 as? TextView, _field = field as? TextView {
                        return _zero == _field
                    }
                    
                    return false
                }) {
                    if orderedIndex > 0 {
                        _field.previous = orderedFields[(orderedIndex - 1)]
                    }

                    if (orderedIndex + 1) < orderedFields.count {
                        _field.next = orderedFields[(orderedIndex + 1)]
                    }
                }
                
                fieldsArray.append(_field)
            }
        }
        
        return fieldsArray
    }
    
    func getFieldName(field:Field) -> String {
        if let f = field as? NSObject {
            
            for (name, _) in properties() {
                guard let prop = valueForKey(name) else {
                    continue
                }
                
                if f.hash == prop.hash {
                    return name
                }
            }
        }
        
        return ""
    }
    
    func setupField(incoming:Field) -> Field {
        let field   = incoming
        field.form  = self
        
        if let _self = self as? FormFieldDefaults {
            field.font          = _self.font
            field.textColor     = _self.textColor
            field.textAlignment = _self.textAlignment   ?? .Left
            field.keyboardType  = _self.keyboardType    ?? .Default
            
            if  field.validators.count == 0 {
                field.validators = _self.defaultValidation
            }
        }
        
        if let f = field as? TextView, setup = f.setupBlock {
            setup(f)
            
            f.setupBlock = nil
        }

        if let f = field as? TextField, setup = f.setupBlock {
            setup(f)
            
            f.setupBlock = nil
        }
        
        if field is TextField {
            (field as! TextField).setupBlock?((field as! TextField))
        }
        
        if let defaults = self.defaults, value = defaults[field.name] {
            field.value = value
        }

        return field
    }
    
    func properties() -> [String : Field] {
        var token:dispatch_once_t   = 0
        var props:[String : Field]  = [:]
        
        dispatch_once(&token) {
            
            let children = Mirror(reflecting: self).children.filter { $0.label != nil }
            
            for (label, value) in children {
                switch value {
                case is TextView:
                    props[label!] = (value as! TextView)
                    break
                    
                case is TextField:
                    props[label!] = (value as! TextField)
                    break
                    
                default: ()
                    break
                }
            }
        }
        
        return props
    }

}
