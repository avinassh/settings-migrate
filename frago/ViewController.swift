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

    var stocks = [Stock]()

    override func viewDidLoad() {
        super.viewDidLoad()

        stocks = StocksDB.instance.getStocks()

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
        let tgLow = getDouble(string: targetLowTextField.stringValue)
        let tgHigh = getDouble(string: targetHighTextField.stringValue)

        let stock = Stock(name: name)
        stock.createdOn = 0
        stock.updatedOn = 0
        stock.targetLowPrice = tgLow
        stock.targetHighPrice = tgHigh
        stock.currentPrice = 0
        stock.intialPrice = 0

        if StocksDB.instance.addStock(stock: stock) != nil {
            stocks.append(stock)
            let indexSet = NSIndexSet(index: stocks.count-1) as IndexSet
            tableView.insertRows(at: indexSet, withAnimation: .effectFade)
        }
    }

    @IBAction func delete(_ sender: AnyObject) {
        // the value of `tableView.selectedRow` will be -1 if row on tableview is 
        // selected and delete key is pressed
        if tableView.selectedRow > -1 {
            let stock = stocks.remove(at: tableView.selectedRow)
            StocksDB.instance.removeStock(stock: stock)
            tableView.reloadData()
        }
    }
}

extension ViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return stocks.count
    }
}

extension ViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellIdentifier: String = ""
        var value: String = ""
        let stock = stocks[row]

        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = "NameCellID"
            value = stock.name
        }
        else if tableColumn == tableView.tableColumns[1] {
            cellIdentifier = "TargetLowCellID"
            value = String(describing: stock.targetLowPrice)
        } else if tableColumn == tableView.tableColumns[2] {
            cellIdentifier = "TargetHighCellID"
            value = String(describing: stock.targetHighPrice)
        }


        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = value
            return cell
        }
        return nil
    }

}

func getDouble(string: String) -> Double {
    let formatter = NumberFormatter()
    return formatter.number(from: string) as? Double ?? 0
}
