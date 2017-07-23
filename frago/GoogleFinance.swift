//
//  GoogleFinance.swift
//  frago
//
//  Created by avi on 22/07/17.
//  Copyright © 2017 avi.im. All rights reserved.
//

import Foundation
import Alamofire

class GoogleStock {
    let name: String
    let exchange: String
    let lastTradedPrice: Double
    let lastTradedPriceCurrency: String

    init(t: String, e: String, l_fix: String, l_cur: String) {
        self.name = t
        self.exchange = e
        self.lastTradedPrice = getDouble(string: l_fix)
        self.lastTradedPriceCurrency = l_cur
    }

    // Adds the current GoogleStock object to DB
    func addtoDB(targetLow: String, targetHigh: String) -> Bool {
        let stock = Stock(name: self.name)
        stock.createdOn = Int64(Date().timeIntervalSince1970)
        stock.updatedOn = Int64(Date().timeIntervalSince1970)
        stock.targetLowPrice = getDouble(string: targetLow)
        stock.targetHighPrice = getDouble(string: targetHigh)
        stock.currentPrice = self.lastTradedPrice
        stock.intialPrice = self.lastTradedPrice

        if StocksDB.instance.addStock(stock: stock) != nil {
            return true
        } else {
            return false
        }
    }
}

class GoogleFinance {
    private static let apiURL = "https://finance.google.com/finance/info?client=ig&q=NSE:"

    func getStocks(name: String) {
        Alamofire.request("https://finance.google.com/finance/info?client=ig&q=NSE:HDFC,ITC,CDSL").responseString { response in
            if let str = response.result.value {
                let index = str.index(str.startIndex, offsetBy: 3)
                let jsonString = str.substring(from: index)
                let jsonData = jsonString.data(using: .utf8)
                let json = try? JSONSerialization.jsonObject(with: jsonData!, options: [])
                if let array = json as? [Any] {
                    for object in array {
                        let obj = object as! [String: String]
                        print("\(obj["t"]!): \(obj["l_fix"]!)")
                    }
                }
            }
        }
    }
}
