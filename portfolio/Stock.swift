//
//  Stock.swift
//  portfolio
//
//  Created by Bhavik Shah on 5/15/16.
//  Copyright (c) 2016 shah. All rights reserved.
//

import UIKit


class Stock: NSObject {
    var stockTicker: String
    var stockPrice: Double
    var stockGain: String
    var stockLow: Double
    var stockHigh: Double
    var stockCompanyName: String
    
    init(stockTicker: String, stockPrice: Double, stockGain: String, stockLow: Double, stockHigh: Double, stockCompanyName: String) {
        self.stockTicker = stockTicker
        self.stockPrice = stockPrice
        self.stockGain = stockGain
        self.stockLow = stockLow
        self.stockHigh = stockHigh
        self.stockCompanyName = stockCompanyName
        
        super.init()
    }
}
