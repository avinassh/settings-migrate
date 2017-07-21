//
//  Models.swift
//  frago
//
//  Created by avi on 21/07/17.
//  Copyright © 2017 avi.im. All rights reserved.
//

import SQLite

class StocksDB {

    private let stocks = Table("stocks")
    private let name = Expression<String>("name")
    private let createdOn = Expression<Int64>("created_on")
    private let updatedOn = Expression<Int64>("updated_on")
    private let targetLowPrice = Expression<Double>("target_low_price")
    private let targetHighPrice = Expression<Double>("target_high_price")
    private let currentPrice = Expression<Double>("current_price")
    private let intialPrice = Expression<Double>("intial_price")

    static let instance = StocksDB()
    private let db: Connection?

    private init() {

        let path = NSSearchPathForDirectoriesInDomains(
            .applicationSupportDirectory, .userDomainMask, true
            ).first! + "/" + Bundle.main.bundleIdentifier!

        do {
            // create parent directory iff it doesn’t exist
            try FileManager.default.createDirectory(
                atPath: path, withIntermediateDirectories: true, attributes: nil
            )
            db = try Connection("\(path)/db.sqlite3")
            initDB()
        } catch {
            // TODO: Handle this error correctly
            // probbaly exit the app
            fatalError("Failed to connect to DB")
        }
    }

    // creates tables if they not exist
    func initDB() {
        do {
            try db!.run(stocks.create(ifNotExists: true) { table in
                table.column(name, primaryKey: true)
                table.column(createdOn)
                table.column(updatedOn)
                table.column(targetLowPrice)
                table.column(targetHighPrice)
                table.column(currentPrice)
                table.column(intialPrice)
            })
        } catch {
            fatalError("Failed to create tables")
        }
    }

    // returns all stocks
    func getStocks() -> [Stock] {
        var stocks = [Stock]()
        do {
            for stock in try db!.prepare(self.stocks) {
                stocks.append(Stock(
                    name: stock[name]))
            }
        } catch {
            print("Unable to fetch stocks from DB")
        }
        return stocks
    }
}
