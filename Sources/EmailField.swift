//
//  EmailField.swift
//  Inquire
//
//  Created by Wesley Cope on 2/12/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

/// UITextField with email validation by default.
open class EmailField : TextField {
    override open var validators: [ValidationRule] {
        didSet {
            let filtered = validators.filter { $0.pattern == Email.pattern }
            if filtered.count == 0 {
                validators.append(Email)
            }
        }
    }
    
    public required init(validators: [ValidationRule], setup: ((TextField) -> Void)?) {
        super.init(validators: validators, setup: setup)
        
        self.validators.append(Email)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
