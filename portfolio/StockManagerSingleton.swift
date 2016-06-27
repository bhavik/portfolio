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
    func updateListOfSymbols(stocks: NSMutableArray) -> () {
        var stringQuotes = "("
        if stocks.count == 0 {
            stocks.addObject("BAC")
            stocks.addObject("C")
        }
        
        for quoteTuple in stocks {
            stringQuotes = stringQuotes + "\"" + (quoteTuple as! String) + "\","
        }
        stringQuotes = stringQuotes.substringToIndex(stringQuotes.endIndex.predecessor())
        stringQuotes = stringQuotes + ")"
        
        let urlString:String = ("http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol IN" + stringQuotes + "&format=json&env=http://datatables.org/alltables.env").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        
       // var urlString:String = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22AAPL%22,%22GOOG%22%29&env=store://datatables.org/alltableswithkeys&format=json"
        
        
        NSLog("URL STRING IS %@",  urlString);
        
        let url : NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL : url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if((error) != nil) {
                print(error!.localizedDescription)
            }
            else {
                var err: NSError?
                //4: JSON process
                let jsonDict = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                if(err != nil) {
                    print("JSON Error \(err!.localizedDescription)")
                }
                else {
                    //5: Extract the Quotes and Values and send them inside a NSNotification
                    let quotes:NSArray = ((jsonDict.objectForKey("query") as! NSDictionary).objectForKey("results") as! NSDictionary).objectForKey("quote") as! NSArray
                    
                    //print("Value for key1 is", quotes["LastTradePriceOnly"])

                    
                    dispatch_async(dispatch_get_main_queue(), {
                        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationStocksUpdated, object: nil, userInfo: [kNotificationStocksUpdated:quotes])
                    })
                }
            }
        })
        task.resume()
        
    }
    
    func printTest() {
        NSLog("TEST OK")
    }
}
