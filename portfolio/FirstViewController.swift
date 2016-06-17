//
//  FirstViewController.swift
//  portfolio
//
//  Created by Bhavik Shah on 5/1/15.
//  Copyright (c) 2015 shah. All rights reserved.
//

import UIKit
import SQLite


class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var homeTableView: UITableView!
    var stockTickerParam:String!
    var stockPriceParam:String!
    var stockGainParam:String!
    
    
    func getUserStocks() {
        do {
            let db = try Connection("/Users/bhavikshah/code/portfolio/portfolio.db")
            let users = Table("users")
            let stocks = Table("stocks")
            let user_stocks = Table("user_stocks")
            let symbol = Expression<String>("symbol")
            let stock_id = Expression<Int64>("stock_id")
            let id = Expression<Int64>("id")
            let user_id = Expression<Int64>("user_id")
            
            //let email = Expression<Int64>("email_address")
            
            //stock_list = db.prepare("select stock_id from user_stocks where user_id = 1")
            //1 get the email address from facebook
            //2 find the user_id from db using email address
            //3 find list of stocks teh user is following and send that to the update stocks function
//            var stock_list = []
//            
//            for stock_list in try db.prepare("select stock_id from user_stocks where user_id = 1") {
//                let id_val = stock_list[0]!
//                print("id:", id_val)
//            }
            
            
            let query = user_stocks.join(stocks, on: stocks[id] == user_stocks[stock_id]).filter(user_id == 1)
            
            for userStocks in try db.prepare(query) {
                let stockSymbol = userStocks[symbol]
                print("symbol is", stockSymbol)
            }
            
            

        }
        catch {
            print("Error in loading database")
        }
    }

    //stockSymbol, stockPrice, stockSummary, dollarGain, percentGain
    var stocks: [(String, String, String, String, String)] =
    [("AAPL", "130.12", "52 week high 132.44 52 week low 84.24", "12", "2.00"),
        ("GOOG", "540.23", "52 week high 604.23", "-5", "1.00"),
        ("USB", "42.34", "52 week high 45.22", "4", "3.00")]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "CustomTableViewCell", bundle:nil)
        homeTableView.registerNib(nib, forCellReuseIdentifier: "customCell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stocksUpdated:", name: kNotificationStocksUpdated, object: nil)
        
        getUserStocks()
        
        self.updateStocks()

    }
    @IBAction func goBack(segue:UIStoryboardSegue) {
        
    }

    func updateStocks() {
        let stockManager:StockManagerSingleton = StockManagerSingleton.sharedInstance
        stockManager.updateListOfSymbols(stocks)
        
        //Repeat this method after 15 secs. (For simplicity of the tutorial we are not cancelling it never)
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(65 * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            {
                self.updateStocks()
            }
        )
    }
    
    func stocksUpdated(notification: NSNotification) {
        //var values = Array<Dictionary<String,AnyObject>>()
        //values.append(notification.userInfo as!  Dictionary<String, AnyObject>)
        
        let values = (notification.userInfo as! Dictionary<String,NSArray>)
        let stocksReceived:NSArray = values[kNotificationStocksUpdated]!
        
        stocks.removeAll(keepCapacity: false)
        for quote in stocksReceived {
            NSLog("inside stocksReceived")
            let quoteDict:NSDictionary = quote as! NSDictionary
            let quoteSymbol = quoteDict["symbol"] as! String
            let lastTradePrice = quoteDict["LastTradePriceOnly"] as! String
           // var dollarGain = quoteDict["Change"] as Double
            let dollarGain = quoteDict["Change"] as! String
            let changeInPercentString = quoteDict["ChangeinPercent"] as! String

            let myElement: (String, String, String, String, String) = (quoteSymbol, lastTradePrice, "summary", changeInPercentString, dollarGain)
            stocks.append(myElement)

        }
        homeTableView.reloadData()
        NSLog("Symbols Values updated :)")
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stocks.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = self.homeTableView.dequeueReusableCellWithIdentifier("customCell") as! CustomTableViewCell!
        var (ticker, price, summary, dollargain, percentgain) = stocks[indexPath.row]
        
//        switch stocks[indexPath.row].3 {
//            case let x where x < 0.0:
//                cell.backgroundColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
//            case let x where x > 0.0:
//                cell.backgroundColor = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
//            case let x:
//                cell.backgroundColor = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
//        }
        
        cell.loadItem(ticker, price: price, summary: summary, dollargain: dollargain, percentgain: percentgain)
                
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("you selected #\(indexPath.row)!")
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! CustomTableViewCell!
        
        stockTickerParam = currentCell.stockTicker.text
        stockPriceParam = currentCell.stockPrice.text
        stockGainParam = currentCell.stockGain.text
        print("ticker selected #\(stockTickerParam)")
        
        performSegueWithIdentifier("StockDetailView", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "StockDetailView") {
            let viewController = segue.destinationViewController as! StockDetailViewController
            
            viewController.stockTickerSymbol = stockTickerParam
            viewController.stockPriceParam = stockPriceParam
            viewController.stockGainParam = stockGainParam
            
        }
    }
}

