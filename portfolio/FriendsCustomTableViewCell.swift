//
//  FriendsCustomTableViewCell.swift
//  portfolio
//
//  Created by Bhavik Shah on 5/2/15.
//  Copyright (c) 2015 shah. All rights reserved.
//

import Foundation
import UIKit

class FriendsCustomTableViewCell:UITableViewCell {
    
    @IBOutlet var stockTicker: UILabel!
    

    @IBOutlet var stockPrice: UILabel!
    @IBOutlet var stockGain: UILabel!
    var percentgainString:String = ""
    var dollargainString:String = ""
    
    @IBOutlet var friendThumbNail: UIImageView!
    var toggleOff:Bool = true

    func loadItem(ticker: String, price: String, summary: String, dollargain: String, percentgain: String) {
        stockTicker.text = ticker
        stockPrice.text = price
        //stockSummary.text = summary
        //var dollarGainStr:String = String(format:"%d", dollargain)
        //var percentgainStr:String = String(format:"%d", percentgain)
        self.percentgainString = percentgain
        self.dollargainString = dollargain
        stockGain.text = dollargain
        stockGain.clipsToBounds = true
        stockGain.layer.cornerRadius = 5.0
        let tapRec = UITapGestureRecognizer(target: self, action: "toggleStockGains:")
        stockGain.addGestureRecognizer(tapRec)
        
        //cell.textLabel.text = self.items[indexPath.row]
        stockTicker.textColor = UIColor.whiteColor()
       // stockSummary.textColor = UIColor.whiteColor()
        stockPrice.textColor = UIColor.whiteColor()
        stockGain.textColor = UIColor.whiteColor()
        
        stockTicker.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 16)
        //stockSummary.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 14)
        stockPrice.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 14)
        stockGain.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 14)
        
        if (dollargain.hasPrefix("-")) {
            stockGain.backgroundColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            //stockSummary.backgroundColor = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        }
        else {
            //stockSummary.backgroundColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            stockGain.backgroundColor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }

        
        //stockTicker.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        
        //stockTicker.shadowOffset = CGSize(width: 0, height: 1)
    }
    func toggleStockGains(recognizer: UITapGestureRecognizer!) {
        print("you are in toogle method")
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