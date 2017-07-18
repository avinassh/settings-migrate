//
//  ViewController.swift
//  frago
//
//  Created by avi on 18/07/17.
//  Copyright © 2017 avi.im. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var targetLowTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func onSubmit(_ sender: NSButton) {
        let name = nameTextField.stringValue
        let targetLow = targetLowTextField.intValue
        print(name, targetLow)
    }
}

