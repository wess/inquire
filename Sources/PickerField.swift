//
//  PickerField.swift
//  Inquire
//
//  Created by Maddie Zug on 7/27/16.
//
//

import Foundation
import UIKit

/// UITextField with UIPickerView as input method
public class PickerField : TextField {
    public var pickerView:UIPickerView = UIPickerView()
    
    public required init(validators: [ValidationRule], setup: (TextField -> Void)?) {
        super.init(validators: validators, setup: setup)
        
        self.inputView = pickerView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}