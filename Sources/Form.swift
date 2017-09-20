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
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }
    
    var textColor:UIColor {
        return .black
    }
    
    var textAlignment:NSTextAlignment {
        return .left
    }
    
    var keyboardType:UIKeyboardType {
        return .default
    }
    
    var defaultValidation:[ValidationRule] {
        return []
    }
}

/**
 # Form
 Subclass to create a new form that defines fields and their validators.
 */

public typealias Fieldname  = String
public typealias Fieldvalue = String

open class Form : NSObject {
    
    /// Validation instance used for validating form fields.
    open let validation = Validation()
    
    /// The Current field of the form that has focus.
    open var currentField:Field? {
        
        for field in fields {
            switch field {
            case is TextView where (field as! TextView).isFirstResponder:
                return field
            case is TextField where (field as! TextField).isFirstResponder:
                return field
            default:
                continue
            }
        }
        
        return nil
    }
    
    /// Form errors from field validations
    open var errors:[String:[(ValidationType, String)]] = [:]
    
    /// List of form's ordered fields.
    open lazy var fields:[Field] = {
        return self.order()
    }()
    
    /// Specifies if a form (and it's fields) are valid or not.
    open var isValid:Bool {
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
    
    fileprivate var _ordered:[Field] = []
    fileprivate var defaults:[Fieldname:Fieldvalue]? = nil
    
    public init(defaults:[Fieldname:Fieldvalue]? = nil) {
        super.init()
        setupProperties()
        
        self.defaults = defaults
    }
    
    /**
     ## Order
     Must be overridden in subclass. Defines what fields and the order they should be in.
     */
    open func order() -> [Field] {
        fatalError("Must be implemented in subclass, return a list of fields to be displayed")
    }
    
    /**
     ## Form as a responder
     By resigning every field in the form as firstResponder, the form resigns first responder :)
    */
    open func resignFirstResponder() {
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

fileprivate extension Form /* Private */ {
  func setup( _ field:inout Field) {
        field.form  = self
        
        if let _self = self as? FormFieldDefaults {
            field.font          = _self.font
            field.textColor     = _self.textColor
            field.textAlignment = _self.textAlignment   ?? .left
            field.keyboardType  = _self.keyboardType    ?? .default
            
            if  field.validators.count == 0 {
                field.validators = _self.defaultValidation
            }
        }
        
        if let f = field as? TextView, let setup = f.setupBlock {
            setup(f)
        }
            
        else if let f = field as? TextField, let setup = f.setupBlock {
            setup(f)
        }
        
        if let defaults = self.defaults, let value = defaults[field.name] {
            field.value = value
        }
    }

    func setupOrderedNavigation() {
        let ordered = fields
        
        for index in 0 ..< ordered.count {
            let previous    = index - 1
            let next        = index + 1
            let current     = ordered[index]
            
            if previous > -1 {
                current.previousField = ordered[previous]
            }
            
            if next < ordered.count {
                current.nextField = ordered[next]
            }
        }
    }
    
    func setupProperties() {

        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        let children = Mirror(reflecting: self).children.filter { $0.label != nil }
        
        for (label, value) in children {
            guard var item = value as? Field else {
                continue
            }
            
            self.setup(&item)
            
            switch value {
            case is TextView:
                let field   = (item as! TextView)
                field.name  = label!
                
                break
                
            case is TextField:
                let field   = (item as! TextField)
                field.name  = label!

                break
                
            default: ()
                break
            }
        }
            
        self.setupOrderedNavigation()
    }

}






