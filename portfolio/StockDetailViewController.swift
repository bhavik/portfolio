//
//  StockDetailViewController.swift
//  portfolio
//
//  Created by Bhavik Shah on 6/3/15.
//  Copyright (c) 2015 shah. All rights reserved.
//

import Foundation
import UIKit

class StockDetailViewController : UIViewController {
    
    var stockTickerSymbol:String!
    var stockPriceParam:String!
    var stockGainParam:String!
    var stockCompanyName:String!
    var stockPreviousClose:String!
    var stockVolume:String!
    var stockMarketCap:String!
    var stockPeRatio:String!
    var stockOpenPrice:String!
    var stockAverageVolume:String!
    var stockLowPriceYear:String!
    var stockHighPriceYear:String!
    

    @IBOutlet var stockOwnerDesc: UILabel!
    @IBOutlet var stockPrice: UILabel!
    @IBOutlet var stockTicker: UILabel!
    
    @IBOutlet var stockGain: UILabel!
    @IBOutlet var statsLabel: UILabel!
    //@IBOutlet var stockOwners: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stockOwnerDesc.text = "Who else has this stock?"
        statsLabel.text = "Stats"
        print("stock Ticker Symbol is #\(stockTickerSymbol)")
        stockTicker.text = stockTickerSymbol
        stockPrice.text = stockPriceParam
        stockGain.text = stockGainParam
        
        //gesture recoginizer for stock gain label:
        let tapRec = UITapGestureRecognizer(target: self, action: "toggleStockGains:")
        stockGain.addGestureRecognizer(tapRec)
    }
}
