//
//  Models.swift
//  frago
//
//  Created by avi on 21/07/17.
//  Copyright © 2017 avi.im. All rights reserved.
//

import SQLite

class StocksDB {

    private let stock_table = Table("stocks")
    private let name = Expression<String>("name")
    private let createdOn = Expression<Int64>("created_on")
    private let updatedOn = Expression<Int64>("updated_on")
    private let targetLowPrice = Expression<Double>("target_low_price")
    private let targetHighPrice = Expression<Double>("target_high_price")
    private let currentPrice = Expression<Double>("current_price")
    private let intialPrice = Expression<Double>("intial_price")
    private let exchange = Expression<String>("exchange")
    private let currency = Expression<String>("currency")

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
            try db!.run(stock_table.create(ifNotExists: true) { table in
                table.column(name, primaryKey: true)
                table.column(createdOn)
                table.column(updatedOn)
                table.column(targetLowPrice)
                table.column(targetHighPrice)
                table.column(currentPrice)
                table.column(intialPrice)
                table.column(exchange)
                table.column(currency)
            })
        } catch {
            fatalError("Failed to create tables")
        }
    }

    // Add a stock to DB
    func addStock(stock: Stock) -> Int64? {
        do {
            let insert = stock_table.insert(
                name <- stock.name,
                createdOn <- stock.createdOn,
                updatedOn <- stock.updatedOn,
                targetLowPrice <- stock.targetLowPrice,
                targetHighPrice <- stock.targetHighPrice,
                intialPrice <- stock.intialPrice,
                currentPrice <- stock.currentPrice)
            let id = try db!.run(insert)
            return id
        } catch {
            print("Adding a new stock failed: \(error)")
            return nil
        }
    }

    // Remove a stock from the DB
    func removeStock(stock: Stock) -> Bool {
        do {
            let s = stock_table.filter(name == stock.name)
            try db!.run(s.delete())
            return true
        } catch {
            print("Removing the stock failed: \(error)")
        }
        return false
    }


    // returns all stocks
    func getStocks() -> [Stock] {
        var stocks = [Stock]()
        do {
            for stock in try db!.prepare(self.stock_table) {
                stocks.append(Stock(
                    name: stock[name],
                    createdOn: stock[createdOn],
                    updatedOn: stock[updatedOn],
                    targetLow: stock[targetLowPrice],
                    targetHigh: stock[targetHighPrice],
                    currentPrice: stock[currentPrice],
                    initialPrice: stock[intialPrice],
                    exchange: stock[exchange]))
            }
        } catch {
            print("Unable to fetch stocks from DB")
        }
        return stocks
    }
}
