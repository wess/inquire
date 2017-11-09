//
//  Toolbar.swift
//  Inquire
//
//  Created by Wesley Cope on 2/15/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

public typealias FieldBarButtonHandler = ((_ sender:AnyObject?) -> Void)

open class FieldToolbarButtonItem : UIBarButtonItem {
    internal var handler:FieldBarButtonHandler?

    @objc internal func targetAction(_ sender:AnyObject?) {
        self.handler?(sender)
    }
}

public enum ToolbarButtonFlexType {
    case fixed
    case flexible
}

public func ToolbarButtonItem(_ flexType:ToolbarButtonFlexType) -> FieldToolbarButtonItem {
    switch flexType {
    case .fixed:
        return FieldToolbarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)

    case .flexible:
        return FieldToolbarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
}

public func ToolbarButtonItem(_ image: UIImage?, style: UIBarButtonItemStyle, handler:FieldBarButtonHandler?) -> FieldToolbarButtonItem {
    return {
        $0.target   = $0
        $0.handler  = handler
        
        return $0
    }(FieldToolbarButtonItem(image: image, style: style, target: nil, action: #selector(FieldToolbarButtonItem.targetAction(_:))))
}

public func ToolbarButtonItem(_ image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItemStyle, handler:FieldBarButtonHandler?) -> FieldToolbarButtonItem {
    return {
        $0.target   = $0
        $0.handler  = handler
        
        return $0
    }(FieldToolbarButtonItem(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: #selector(FieldToolbarButtonItem.targetAction(_:))))
}

public func ToolbarButtonItem(_ title: String?, style: UIBarButtonItemStyle, handler:FieldBarButtonHandler?) -> FieldToolbarButtonItem {
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













