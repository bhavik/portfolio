    //
//  StockManagerSingleton.swift
//  portfolio
//
//  Created by Bhavik Shah on 5/22/15.
//  Copyright (c) 2015 shah. All rights reserved.
//

import Foundation
let kNotificationStocksUpdated = "stocksUpdated"

class StockManagerSingleton {
    
    class var sharedInstance : StockManagerSingleton {
        struct Static {
            static let instance : StockManagerSingleton = StockManagerSingleton()
        }
        return Static.instance
    }
    func updateListOfSymbols(_ stocks: NSMutableArray) -> () {
        var stringQuotes = "("
        if stocks.count == 0 {
            stocks.add("BAC")
            stocks.add("C")
        }
        
        for quoteTuple in stocks {
            stringQuotes = stringQuotes + "\"" + (quoteTuple as! String) + "\","
        }
        stringQuotes = stringQuotes.substring(to: stringQuotes.characters.index(before: stringQuotes.endIndex))
        stringQuotes = stringQuotes + ")"
        
        let urlString:String = ("http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol IN" + stringQuotes + "&format=json&env=http://datatables.org/alltables.env").addingPercentEscapes(using: String.Encoding.utf8)!
        
        
       // var urlString:String = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22AAPL%22,%22GOOG%22%29&env=store://datatables.org/alltableswithkeys&format=json"
        
        
        NSLog("URL STRING IS %@",  urlString);
        
        let url : URL = URL(string: urlString)!
        let request: URLRequest = URLRequest(url : url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            if((error) != nil) {
                print(error!.localizedDescription)
            }
            else {
                let err: NSError
                //4: JSON process
                do { let jsonDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    //5: Extract the Quotes and Values and send them inside a NSNotification
                    let quotes:NSArray = (((jsonDict as AnyObject).object(forKey: "query") as! NSDictionary).object(forKey: "results") as! NSDictionary).object(forKey: "quote") as! NSArray
                    
                    sprint("Value for key1 is", quotes["LastTradePriceOnly"])
                    
                    
                    DispatchQueue.main.async(execute: {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationStocksUpdated), object: nil, userInfo: [kNotificationStocksUpdated:quotes])
                    })
                    
                }
                catch let err as NSError {
                 print("JSON Error \(err.localizedDescription)")
                }
            }
        })
        task.resume()
        
    }
    
    func printTest() {
        NSLog("TEST OK")
    }
}
