//
//  AddViewController.swift
//  frago
//
//  Created by avi on 23/07/17.
//  Copyright © 2017 avi.im. All rights reserved.
//

import Foundation
import Cocoa

protocol AddViewControllerDelegate{
    func addViewDismissed()
}


class AddViewController: NSViewController {

    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var targetLowTextField: NSTextField!
    @IBOutlet weak var targetHighTextField: NSTextField!
    @IBOutlet weak var submitButton: NSButton!

    var delegate:AddViewControllerDelegate? = nil

    @IBAction func onSubmit(_ sender: NSButton) {
        self.toggleButton()
        let name = nameTextField.stringValue
        let targetLow = targetLowTextField.stringValue
        let targetHigh = targetHighTextField.stringValue
        GoogleFinance.addStock(name: name, targetLow: targetLow, targetHigh: targetHigh, addViewController: self)
    }

    func close() {
        self.delegate?.addViewDismissed()
        self.dismiss(nil)
    }

    // if the response from Google is non 200, handle that here
    func onFailure(message: String) {

        let alert = NSAlert.init()
        alert.messageText = "Adding a new stock failed"
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.runModal()

        self.resetTextFields()
        self.toggleButton()
    }


    func toggleButton() {
        if self.submitButton.isEnabled {
            self.submitButton.isEnabled = false
        } else {
            self.submitButton.isEnabled = true
        }
    }

    func resetTextFields() {
        nameTextField.stringValue = ""
        targetLowTextField.stringValue = ""
        targetHighTextField.stringValue = ""
    }
}
