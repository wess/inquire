//
//  TextView.swift
//  Inquire
//
//  Created by Wesley Cope on 1/13/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

/// UITextView for use with Form.
open class TextView : UITextView, Field {
    /// Placeholder for empty field
    open var placeholder:String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var placeholderColor:UIColor = UIColor(white: 0.8, alpha: 0.8) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Form containing field.
    open var form:Form?
    
    /// Previous field
    open var previousField:Field?
    
    /// Next field
    open var nextField:Field?

    /// Block called when the field isn't valid.
    open var onError:FieldErrorHandler?
    
    /// Name of field, default to property name in form.
    open var name:String = ""
    
    /// meta data for field
    open var meta:[String:AnyObject] = [:]
    
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
    
    internal var setupBlock:((TextView) -> Void)? = nil
    
    public required init(placeholder:String? = nil, validators:[ValidationRule] = [], setup:((TextView) -> Void)? = nil) {
        super.init(frame: .zero, textContainer: nil)
        
        self.validators = validators
        self.setupBlock = setup
        
        NotificationCenter.default.addObserver(self, selector: #selector(TextView.textChanged(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
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
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard text.isEmpty else { return }
        guard let placeholder = self.placeholder else { return }
        
        var placeholderAttributes = typingAttributes ?? [String: AnyObject]()
        
        if placeholderAttributes[NSFontAttributeName] == nil {
            placeholderAttributes[NSFontAttributeName] = typingAttributes[NSFontAttributeName] ?? font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        
        if placeholderAttributes[NSParagraphStyleAttributeName] == nil {
            let typingParagraphStyle = typingAttributes[NSParagraphStyleAttributeName]
            if typingParagraphStyle == nil {
                let paragraphStyle              = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
                paragraphStyle.alignment        = textAlignment
                paragraphStyle.lineBreakMode    = textContainer.lineBreakMode
                
                placeholderAttributes[NSParagraphStyleAttributeName] = paragraphStyle
            } else {
                placeholderAttributes[NSParagraphStyleAttributeName] = typingParagraphStyle
            }
        }
        
        placeholderAttributes[NSForegroundColorAttributeName] = placeholderColor
        
        let placeholderRect = rect.insetBy(dx: contentInset.left + textContainerInset.left + textContainer.lineFragmentPadding, dy: contentInset.top + textContainerInset.top)
        
        placeholder.draw(in: placeholderRect, withAttributes: placeholderAttributes)
    }
}

extension TextView /* Internal */ {
    internal func textChanged(_ notification:Notification) {
        guard let textView = notification.object as? TextView, textView == self else {
            return
        }
        
        setNeedsDisplay()
    }
}







