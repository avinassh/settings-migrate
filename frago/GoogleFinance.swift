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

    static func addStock(name: String, targetLow: String, targetHigh: String,
                         addViewController: AddViewController) {
        Alamofire.request("https://finance.google.com/finance/info?client=ig&q=NSE:\(name)")
            .responseString { response in

                if response.response?.statusCode != 200 {
                    addViewController.onFailure()
                    return
                }

                if let str = response.result.value {
                    let index = str.index(str.startIndex, offsetBy: 3)
                    let jsonString = str.substring(from: index)
                    let jsonData = jsonString.data(using: .utf8)
                    var obj = [String: String]()
                    let json = try? JSONSerialization.jsonObject(with: jsonData!, options: [])
                    let array = json as? [Any]
                    obj = array?[0] as! [String: String]
                    let googleStock = GoogleStock(t: obj["t"]!, e: obj["e"]!,
                                                  l_fix: obj["l_fix"]!, l_cur: obj["l_cur"]!)
                    if googleStock.addtoDB(targetLow: targetLow, targetHigh: targetHigh) {
                        addViewController.close()
                    } else {
                        addViewController.onFailure()
                    }
                }
        }
    }
}
