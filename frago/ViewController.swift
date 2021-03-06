//
//  ViewController.swift
//  frago
//
//  Created by avi on 18/07/17.
//  Copyright © 2017 avi.im. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, AddViewControllerDelegate {

    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var targetLowTextField: NSTextField!
    @IBOutlet weak var targetHighTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var timeStampLabel: NSTextField!

    var stocks = [Stock]()

    override func viewDidLoad() {
        super.viewDidLoad()

        stocks = StocksDB.instance.getStocks()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.target = self
    }

    override func viewDidAppear() {
        // Disable window resizing and zoom
        self.view.window?.styleMask.remove(NSWindowStyleMask.resizable)
        // Disable column reordering and resizing
        tableView.allowsColumnResizing = false
        tableView.allowsColumnReordering = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func onSubmit(_ sender: NSButton) {
        let stock = Stock(name: nameTextField.stringValue)
        stock.createdOn = Int64(Date().timeIntervalSince1970)
        stock.updatedOn = Int64(Date().timeIntervalSince1970)
        stock.targetLowPrice = getDouble(string: targetLowTextField.stringValue)
        stock.targetHighPrice = getDouble(string: targetHighTextField.stringValue)
        stock.currentPrice = 0
        stock.intialPrice = 0

        if StocksDB.instance.addStock(stock: stock) != nil {
            stocks.append(stock)
            let indexSet = NSIndexSet(index: stocks.count-1) as IndexSet
            tableView.insertRows(at: indexSet, withAnimation: .effectFade)
        }
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddView" {
            let vc = segue.destinationController as! AddViewController
            vc.delegate = self
        }
    }

    @IBAction func newDocument(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ShowAddView", sender: self)
    }

    // TODO: Optimize this method. Should be called only if new row was added.
    // OR write a method which takes the last added row from DB and adds that
    // row to tableview
    func addViewDismissed() {
        stocks = StocksDB.instance.getStocks()
        tableView.reloadData()
    }

    @IBAction func delete(_ sender: AnyObject) {
        // the value of `tableView.selectedRow` will be -1 if row on tableview is 
        // selected and delete key is pressed
        if tableView.selectedRow <= -1 {
            return
        }
        let stock = stocks.remove(at: tableView.selectedRow)
        if StocksDB.instance.removeStock(stock: stock) {
            let indexSet = NSIndexSet(index: tableView.selectedRow) as IndexSet
            tableView.removeRows(at: indexSet, withAnimation: [])
        } else {
            // removal failed for some reason 🤔
            // put the item back in array
            stocks.insert(stock, at: tableView.selectedRow)
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
        } else if tableColumn == tableView.tableColumns[1] {
            cellIdentifier = "InitialPriceCellID"
            value = getCurrencyString(price: stock.intialPrice, currency: stock.currency)
        } else if tableColumn == tableView.tableColumns[2] {
            cellIdentifier = "CurrentPriceCellID"
            value = getCurrencyString(price: stock.currentPrice, currency: stock.currency)
        } else if tableColumn == tableView.tableColumns[3] {
            cellIdentifier = "TargetLowCellID"
            value = getCurrencyString(price: stock.targetLowPrice, currency: stock.currency)
        } else if tableColumn == tableView.tableColumns[4] {
            cellIdentifier = "TargetHighCellID"
            value = getCurrencyString(price: stock.targetHighPrice, currency: stock.currency)
        }

        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = value
            return cell
        }
        return nil
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow <= -1 {
            timeStampLabel.stringValue = ""
            return
        }
        let stock = stocks[tableView.selectedRow]
        let createdOn = NSDate(timeIntervalSince1970: TimeInterval(stock.createdOn))
        let updatedOn = NSDate(timeIntervalSince1970: TimeInterval(stock.updatedOn))

        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-YYYY, hh:mm a"
        let createdOnString = formatter.string(from: createdOn as Date)
        let updatedOnString = formatter.string(from: updatedOn as Date)
        timeStampLabel.stringValue = "Added on: \(createdOnString), Last updated on: \(updatedOnString)"
    }


}

func getDouble(string: String) -> Double {
    let formatter = NumberFormatter()
    return formatter.number(from: string) as? Double ?? 0
}

func getCurrencyString(price: Double, currency: String) -> String {
    return currency + String(format: "%.02f", price)
}
