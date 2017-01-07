//
//  File.swift
//  playGround
//
//  Created by Bhavik Shah on 4/30/15.
//  Copyright (c) 2015 shah. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var stockTicker: UILabel!
    @IBOutlet var stockPrice: UILabel!
    @IBOutlet var stockHigh: UILabel!
    @IBOutlet var stockLow: UILabel!
    @IBOutlet var stockGain: UILabel!
    
    var percentgainString:String = ""
    var dollargainString:String = ""
    
    var toggleOff:Bool = true
    
    func loadItem(_ ticker: String, price: String, summary: String, dollargain: String, percentgain: String) {
        //get values
        stockTicker.text = ticker
        stockPrice.text = price
        stockLow.text = summary
        stockHigh.text = summary
        //var dollarGainStr:String = String(format:"%d", dollargain)
        //var percentgainStr:String = String(format:"%d", percentgain)
        self.percentgainString = percentgain
        self.dollargainString = dollargain
        stockGain.text = dollargain
        stockGain.clipsToBounds = true
        stockGain.layer.cornerRadius = 5.0
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(CustomTableViewCell.toggleStockGains(_:)))
        stockGain.addGestureRecognizer(tapRec)
        
        //cell.textLabel.text = self.items[indexPath.row]
        //add color
        stockTicker.textColor = UIColor.white
        stockHigh.textColor = UIColor.white
        stockLow.textColor = UIColor.white
        stockPrice.textColor = UIColor.white
        stockGain.textColor = UIColor.white
        
        //add font
        stockTicker.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 16)
        stockHigh.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 12)
        stockLow.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 12)
        stockPrice.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 18)
        stockGain.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 16)
        
        //add shadow
        stockTicker.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        stockTicker.shadowOffset = CGSize(width: 0, height: 0)
        
        //change color depending on positive or negative gain
        if (dollargain.hasPrefix("-")) {
            stockGain.backgroundColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        else {
            stockGain.backgroundColor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        
    }
    func toggleStockGains(_ recognizer: UITapGestureRecognizer!) {
        if (toggleOff) {
            stockGain.text = self.percentgainString
            toggleOff = false
        }
        else {
            stockGain.text = self.dollargainString
            toggleOff = true
        }
    }
}
