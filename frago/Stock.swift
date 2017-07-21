//
//  Stock.swift
//  frago
//
//  Created by avi on 21/07/17.
//  Copyright © 2017 avi.im. All rights reserved.
//

import Foundation

class Stock {
    let name: String?
    let createdOn: Int64
    var updatedOn: Int64
    var targetLowPrice: Double
    var targetHighPrice: Double
    var currentPrice: Double
    var intialPrice: Double

    init(name: String) {
        self.name = name
        self.createdOn = 0
        self.updatedOn = 0
        self.targetLowPrice = 0.0
        self.targetHighPrice = 0.0
        self.currentPrice = 0.0
        self.intialPrice = 0.0
    }
}
