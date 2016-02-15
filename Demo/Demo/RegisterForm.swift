//
//  RegisterForm.swift
//  Demo
//
//  Created by Wesley Cope on 2/11/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import Inquire

class RegisterForm : Form {
    let email       = EmailField(validators: [Required,]) { field in
        field.placeholder   = "Email Address"
        field.toolbarItems  = [
            ToolbarButtonItem("NEXT", style: .Done) { sender in
                if let next = field.next {
                    field.move(next)
                }
            }
        ]
    }
    
    let password    = PasswordField(validators: [Required,]) { field in
        field.placeholder = "Password"
    }
    
    override func order() -> [Field] {
        return [email, password,]
    }
}