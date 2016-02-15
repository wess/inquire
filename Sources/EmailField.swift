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
public class EmailField : TextField {
    public required init(validators: [ValidationRule], setup: (TextField -> Void)?) {
        super.init(validators: validators, setup: setup)
        
        self.validators.append(Email)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}