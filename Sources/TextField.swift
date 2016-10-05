//
//  TextField.swift
//  Inquire
//
//  Created by Wesley Cope on 1/13/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

/// UITextField with name, validators, and errors for usage with Form.
open class TextField : UITextField, Field {
    /// Form containing field.
    open var form:Form?
    
    /// Previous Field in form
    open var previousField: Field?

    /// Next field
    open var nextField:Field?

    /// Block called when the field isn't valid.
    open var onError:FieldErrorHandler?

    /// Name of field, default to property name in form.
    open var name:String = ""
    
    /// Title of field, usually the same as Placeholder
    open var title:String = ""

    /// meta data for field
    open var meta:[String:AnyObject] = [:]
    
    /// Input toolbar
    fileprivate lazy var toolbar:UIToolbar = {
        let frame       = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        let _toolbar    = UIToolbar(frame: frame)
        
        return _toolbar
    }()
    
    /// Items for field toolbar.
    open var toolbarItems:[FieldToolbarButtonItem]? {
        didSet {
            inputAccessoryView = nil
        
            if let items = toolbarItems , items.count > 0 {
                toolbar.items       = items
                inputAccessoryView  = toolbar
            }
        }
    }
    
    /// Validators used against value of field.
    open var validators:[ValidationRule]  = []
    
    /// Field errors.
    open var errors:[(ValidationType, String)] = []
    
    /// Field's value.
    open var value:String? {
        get {
            return self.text
        }
        
        set {
            self.text = String(describing: newValue)
        }
    }

    open var setupBlock:((TextField) -> Void)? = nil
    
    public convenience init(placeholder:String?) {
        self.init(validators:[], setup:nil)

        self.placeholder = placeholder
    }
    
    public convenience init(placeholder:String?, setup:((TextField) -> Void)?) {
        self.init(validators:[], setup:setup)
    
        self.placeholder = placeholder
    }
    
    public convenience init(placeholder:String?, validators:[ValidationRule]?) {
        self.init(validators:validators ?? [], setup:nil)

        self.placeholder = placeholder
    }
    
    public convenience init(placeholder:String?, validators:[ValidationRule]?, setup:((TextField) -> Void)?) {
        self.init(validators:validators ?? [], setup:setup)
        
        self.placeholder = placeholder
    }
    
    public convenience init() {
        self.init(validators:[], setup:nil)
    }

    public convenience init(setup:((TextField) -> Void)?) {
        self.init(validators:[], setup:setup)
    }
    
    public convenience init(validators:[ValidationRule] = []) {
        self.init(validators:validators, setup:nil)
    }

    public required init(validators:[ValidationRule] = [], setup:((TextField) -> Void)?) {
        super.init(frame: .zero)
        
        self.validators = validators
        self.setupBlock = setup
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func move(_ to:Field) {
        resignFirstResponder()
        
        if let field = to as? TextField {
            field.becomeFirstResponder()
        }
        
        if let field = to as? TextView {
            field.becomeFirstResponder()
        }
    }

}







