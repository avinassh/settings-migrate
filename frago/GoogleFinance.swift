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
        stock.exchange = self.exchange
        stock.currency = getCurrency(currencyPrice: self.lastTradedPriceCurrency)

        if StocksDB.instance.addStock(stock: stock) != nil {
            return true
        } else {
            return false
        }
    }
}

class GoogleFinance {
    private static let apiURL = "https://finance.google.com/finance/info?client=ig&q="

    static func addStock(name: String, targetLow: String, targetHigh: String,
                         addViewController: AddViewController) {
        Alamofire.request("\(apiURL)\(name)")
            .responseString { response in

                if response.response?.statusCode != 200 {
                    let m = "Unable to find \(name) on NSE. Make sure symbol is valid."
                    addViewController.onFailure(message: m)
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
                        let m = "Symbol \(name) alreday exist. Try adding something new?"
                        addViewController.onFailure(message: m)
                    }
                }
        }
    }
}

// `currencyPrice` is from Google, is a string contains the price and also
// price symbol. For US exchanges, it doesn't contain any symbol
//
// eg.: "1,246" (for NASDAQ, NYSE etc)
// eg.: "₹127" (for BSE, NSE etc)
func getCurrency(currencyPrice: String) -> String {
    // if the first character is a number, return $ else whatever that 
    // character is
    let regEx  = "^[0-9].*"
    let testCase = NSPredicate(format:"SELF MATCHES %@", regEx)
    if testCase.evaluate(with: currencyPrice) {
        return "$"
    }
    let currencyPriceHTML = currencyPrice.html2AttributedString
    let firstCharIndex = currencyPriceHTML.index(currencyPriceHTML.startIndex, offsetBy: 1)
    return currencyPriceHTML.substring(to: firstCharIndex)
}

extension String {
    var html2AttributedString: String {
        do {
            let val = try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return val.string
        } catch {
            print(error)
            return "$"
        }
    }
}
