//
//  TextFieldDelegate.swift
//  UdaCity Map
//
//  Created by Abdalfattah Altaeb on 4/13/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {

    // Resign first responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Clear text at the start of edit
    // - Parameter textField: text contents
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""

    }
}
