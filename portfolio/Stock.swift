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
    var stockPrice: String
    var stockGain: String
    var stockLow: Double
    var stockHigh: Double
    var stockCompanyName: String
    var stockPercentGain: String
    
    var previousClose: String
    var volume: String
    var marketCap: String
    var peRatio: String
    var openPrice: String
    var averageVolume: String
    var lowPriceYear: String
    var highPriceYear: String
    
    
    init(stockTicker: String, stockPrice: String, stockGain: String, stockLow: Double, stockHigh: Double, stockCompanyName: String, stockPercentGain: String, previousClose: String, volume: String, marketCap: String, peRatio: String, openPrice: String, averageVolume: String, lowPriceYear: String, highPriceYear: String) {
        self.stockTicker = stockTicker
        self.stockPrice = stockPrice
        self.stockGain = stockGain
        self.stockLow = stockLow
        self.stockHigh = stockHigh
        self.stockCompanyName = stockCompanyName
        self.stockPercentGain = stockPercentGain
        
        self.previousClose = previousClose
        self.volume = volume
        self.marketCap = marketCap
        self.peRatio = peRatio
        self.openPrice = openPrice
        self.averageVolume = averageVolume
        self.lowPriceYear = lowPriceYear
        self.highPriceYear = highPriceYear
        
        super.init()
    }
}
