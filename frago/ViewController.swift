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
    @IBOutlet weak var targetHighTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!

    var names: [String] = ["Python", "Go", "Swift"]
    var targetLow: [String] = ["3.6", "1.9", "3"]
    var targetHigh: [String] = ["2.9", "1.6", "1"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.target = self

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func onSubmit(_ sender: NSButton) {
        let name = nameTextField.stringValue
        let tgLow = targetLowTextField.stringValue
        let tgHigh = targetHighTextField.stringValue
        names.append(name)
        targetLow.append(tgLow)
        targetHigh.append(tgHigh)
        tableView.reloadData()
    }

}

extension ViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return names.count
    }
}

extension ViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellIdentifier: String = ""
        var value: String = ""
        
        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = "NameCellID"
            value = names[row]
            
        } else if tableColumn == tableView.tableColumns[1] {
            cellIdentifier = "TargetLowCellID"
            value = targetLow[row]
        } else if tableColumn == tableView.tableColumns[2] {
            cellIdentifier = "TargetHighCellID"
            value = targetHigh[row]
        }
        

        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = value
            return cell
        }
        return nil
    }
}
