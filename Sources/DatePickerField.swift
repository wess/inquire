//
//  DatePickerField.swift
//  Inquire
//
//  Created by Maddie Zug on 7/29/16.
//
//

import Foundation
import UIKit

/// UITextField with UIDatePicker as input method
public class DatePickerField : TextField {
    public var datePicker:UIDatePicker = UIDatePicker()
    
    public required init(validators: [ValidationRule], setup: (TextField -> Void)?) {
        super.init(validators: validators, setup: setup)
        
        self.inputView = datePicker
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}