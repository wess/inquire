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
public class TextView : UITextView, Field {
    /// Placeholder for empty field
    public var placeholder:String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var placeholderColor:UIColor = UIColor(white: 0.8, alpha: 0.8) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Form containing field.
    public var form:Form?
    
    /// Previous field
    public var previous:Field?
    
    /// Next field
    public var next:Field?

    /// Block called when the field isn't valid.
    public var onError:FieldErrorHandler?
    
    /// Name of field, default to property name in form.
    public var name:String = ""
    
    /// meta data for field
    public var meta:[String:AnyObject] = [:]
    
    private lazy var toolbar:UIToolbar = {
        let frame       = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 44)
        let _toolbar    = UIToolbar(frame: frame)
        
        return _toolbar
    }()
    
    /// Items for field toolbar.
    public var toolbarItems:[FieldToolbarButtonItem]? {
        didSet {
            inputAccessoryView = nil
        
            if let items = toolbarItems where items.count > 0 {
                toolbar.items       = items
                inputAccessoryView  = toolbar
            }
        }
    }

    /// Validators used against value of field.
    public var validators:[ValidationRule]  = []
    
    /// Field errors.
    public var errors:[(ValidationType, String)] = []
    
    /// Field's value.
    public var value:String? {
        get {
            return self.text
        }
        
        set {
            self.text = String(newValue)
        }
    }
    
    internal var setupBlock:(TextView -> Void)? = nil
    
    public required init(placeholder:String? = nil, validators:[ValidationRule] = [], setup:(TextView -> Void)? = nil) {
        super.init(frame: .zero, textContainer: nil)
        
        self.validators = validators
        self.setupBlock = setup
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextView.textChanged(_:)), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    public func move(to:Field) {
        resignFirstResponder()
        
        if let field = to as? TextField {
            field.becomeFirstResponder()
        }
        
        if let field = to as? TextView {
            field.becomeFirstResponder()
        }
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        guard text.isEmpty else { return }
        guard let placeholder = self.placeholder else { return }
        
        var placeholderAttributes = typingAttributes ?? [String: AnyObject]()
        
        if placeholderAttributes[NSFontAttributeName] == nil {
            placeholderAttributes[NSFontAttributeName] = typingAttributes[NSFontAttributeName] ?? font ?? UIFont.systemFontOfSize(UIFont.systemFontSize())
        }
        
        if placeholderAttributes[NSParagraphStyleAttributeName] == nil {
            let typingParagraphStyle = typingAttributes[NSParagraphStyleAttributeName]
            if typingParagraphStyle == nil {
                let paragraphStyle              = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
                paragraphStyle.alignment        = textAlignment
                paragraphStyle.lineBreakMode    = textContainer.lineBreakMode
                
                placeholderAttributes[NSParagraphStyleAttributeName] = paragraphStyle
            } else {
                placeholderAttributes[NSParagraphStyleAttributeName] = typingParagraphStyle
            }
        }
        
        placeholderAttributes[NSForegroundColorAttributeName] = placeholderColor
        
        let placeholderRect = CGRectInset(rect, contentInset.left + textContainerInset.left + textContainer.lineFragmentPadding, contentInset.top + textContainerInset.top)
        
        placeholder.drawInRect(placeholderRect, withAttributes: placeholderAttributes)
    }
}

extension TextView /* Internal */ {
    internal func textChanged(notification:NSNotification) {
        guard let object = notification.object where object === self else { return }
        
        setNeedsDisplay()
    }
}







