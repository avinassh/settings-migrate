//
//  Stock.swift
//  frago
//
//  Created by avi on 21/07/17.
//  Copyright © 2017 avi.im. All rights reserved.
//

import Foundation

class Stock {
    let name: String
    var createdOn: Int64
    var updatedOn: Int64
    var targetLowPrice: Double
    var targetHighPrice: Double
    var currentPrice: Double
    var intialPrice: Double
    var exchange: String
    var currency: String

    // this init is used whenever a new Stock is to be added to DB
    init(name: String) {
        self.name = name
        self.createdOn = 0
        self.updatedOn = 0
        self.targetLowPrice = 0.0
        self.targetHighPrice = 0.0
        self.currentPrice = 0.0
        self.intialPrice = 0.0
        self.exchange = ""
        self.currency = ""
    }

    // this init is used whenever a new Stock is loaded from the DB
    init(name: String, createdOn: Int64, updatedOn: Int64, targetLow: Double,
         targetHigh: Double, currentPrice: Double, initialPrice: Double,
         exchange: String, currency: String) {
        self.name = name
        self.createdOn = createdOn
        self.updatedOn = updatedOn
        self.targetLowPrice = targetLow
        self.targetHighPrice = targetHigh
        self.currentPrice = currentPrice
        self.intialPrice = initialPrice
        self.exchange = exchange
        self.currency = currency
    }
}
