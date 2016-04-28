//
//  Toolbar.swift
//  Inquire
//
//  Created by Wesley Cope on 2/15/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

public typealias FieldBarButtonHandler = ((sender:AnyObject?) -> Void)

public class FieldToolbarButtonItem : UIBarButtonItem {
    internal var handler:FieldBarButtonHandler?

    internal func targetAction(sender:AnyObject?) {
        self.handler?(sender: sender)
    }
}

public enum ToolbarButtonFlexType {
    case Fixed
    case Flexible
}

public func ToolbarButtonItem(flexType:ToolbarButtonFlexType) -> FieldToolbarButtonItem {
    switch flexType {
    case .Fixed:
        return FieldToolbarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)

    case .Flexible:
        return FieldToolbarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    }
}

public func ToolbarButtonItem(image: UIImage?, style: UIBarButtonItemStyle, handler:FieldBarButtonHandler?) -> FieldToolbarButtonItem {
    return {
        $0.target   = $0
        $0.handler  = handler
        
        return $0
    }(FieldToolbarButtonItem(image: image, style: style, target: nil, action: #selector(FieldToolbarButtonItem.targetAction(_:))))
}

public func ToolbarButtonItem(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItemStyle, handler:FieldBarButtonHandler?) -> FieldToolbarButtonItem {
    return {
        $0.target   = $0
        $0.handler  = handler
        
        return $0
    }(FieldToolbarButtonItem(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: #selector(FieldToolbarButtonItem.targetAction(_:))))
}

public func ToolbarButtonItem(title: String?, style: UIBarButtonItemStyle, handler:FieldBarButtonHandler?) -> FieldToolbarButtonItem {
    return {
        $0.target   = $0
        $0.handler  = handler
        
        return $0
    }(FieldToolbarButtonItem(title: title, style: style, target: nil, action: #selector(FieldToolbarButtonItem.targetAction(_:))))
}

public func ToolbarButtonItem(barButtonSystemItem systemItem: UIBarButtonSystemItem, handler:FieldBarButtonHandler?) -> FieldToolbarButtonItem {
    return {
        $0.target   = $0
        $0.handler  = handler
        
        return $0
    }(FieldToolbarButtonItem(barButtonSystemItem: systemItem, target: nil, action: #selector(FieldToolbarButtonItem.targetAction(_:))))
}













