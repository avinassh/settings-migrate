//
//  Models.swift
//  frago
//
//  Created by avi on 21/07/17.
//  Copyright © 2017 avi.im. All rights reserved.
//

import SQLite

class StocksDB {

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
        } catch {
            // TODO: Handle this error correctly
            // probbaly exit the app
            fatalError("Failed to connect to DB")
        }
    }
}
