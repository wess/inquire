//
//  PasswordField.swift
//  Inquire
//
//  Created by Wesley Cope on 1/14/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

/// UITextField with security entry always set to true.
open class PasswordField : TextField {
        public required init(validators:[ValidationRule] = [], setup:((TextField) -> Void)? = nil) {
        super.init(validators: validators, setup: setup)
        
        self.isSecureTextEntry = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


