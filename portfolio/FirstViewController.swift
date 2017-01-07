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
    var myStockList: NSMutableArray = []
    var myStocks: NSMutableArray = []
    
    //user detail
    var userName = ""
    var userEmail = ""
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "CustomTableViewCell", bundle:nil)
        homeTableView.register(nib, forCellReuseIdentifier: "customCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.stocksUpdated(_:)), name: NSNotification.Name(rawValue: kNotificationStocksUpdated), object: nil)
        self.updateStocks()
        
    }
    @IBAction func goBack(_ segue:UIStoryboardSegue) {
        
    }
    
    func getUserStocks(_ currentUser: User) -> NSMutableArray{
        print("Inside getUserStocks")
        let stock_list: NSMutableArray = []
        do {
            let db = try Connection("/Users/bhavikshah/code/portfolio/portfolio.db")
            let users = Table("users")
            let stocks = Table("stocks")
            let user_stocks = Table("user_stocks")
            let symbol = Expression<String>("symbol")
            let stock_id = Expression<Int64>("stock_id")
            let id = Expression<Int64>("id")
            let user_id = Expression<Int64>("user_id")
            let user_email = Expression<String>("email_address")
            
            //let email = Expression<Int64>("email_address")
            
            //stock_list = db.prepare("select stock_id from user_stocks where user_id = 1")
            //1 get the email address from facebook
            //2 find the user_id from db using email address
            //3 find list of stocks teh user is following and send that to the update stocks function
            //
//            for stock_list in try db.prepare("select stock_id from user_stocks where user_id = 1") {
//                let id_val = stock_list[0]!
//                print("id:", id_val)
//            }
            //let current_user = users.filter(user_email == currentUser.userEmail)
            //print("currentUser.userEmail is", currentUser.userEmail)
           // print("ID  is: \(current_user[id].absoluteValue)")
            
            //sowmehow we are not getting the actual ID using this above query so defaulting to user_id value 1
            
            let query = user_stocks.join(stocks, on: stocks[id] == user_stocks[stock_id]).filter(user_id == 1)
            
            for userStocks in try db.prepare(query) {
                print("inside userStocks")
                let stockSymbol = userStocks[symbol]
                stock_list.add(stockSymbol)
                print("symbol is", stockSymbol)
            }
        }
        catch {
            print("Error in loading database")
        }
        return stock_list
    }



    
    func updateStocks() {
        print("Inside updateStocks")
        let stockManager:StockManagerSingleton = StockManagerSingleton.sharedInstance
        //let currentUser : User = getUserInfo()
        //myStockList = getUserStocks(currentUser)
        getUserInfo()
        
        stockManager.updateListOfSymbols(myStockList)
        
        //Repeat this method after 15 secs. (For simplicity of the tutorial we are not cancelling it never)
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(65 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: {
                self.updateStocks()
            }
        )
    }
    
    
    func getUserInfo() -> Void {
        print("Inside getUserInfo")
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name"])
        
        graphRequest.start(completionHandler:{ (connection, result, error) -> Void in
        
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]

                
                print("fetched user: \(result)")
                self.userName = data["name"] as! String
                
                print("self.userEmail", self.userEmail)

                
                print("User Name is: \(self.userName)")
                self.userEmail  = data["email"] as! String
                print("User Email is: \(self.userEmail)")
                self.userId = data["id"] as! String
                
                let current_user = User(userName: self.userName, userEmail: self.userEmail, userId: self.userId)
                self.myStockList = self.getUserStocks(current_user)

            }
        })
          print("Finished getUserInfo")

    }

    
    func stocksUpdated(_ notification: Notification) {
        print("Inside stocksUpdated")
        //var values = Array<Dictionary<String,AnyObject>>()
        //values.append(notification.userInfo as!  Dictionary<String, AnyObject>)
        
        let values = (notification.userInfo as! Dictionary<String,NSArray>)
        let stocksReceived:NSArray = values[kNotificationStocksUpdated]!
        
        myStocks.removeAllObjects()
        for quote in stocksReceived {
            NSLog("inside stocksReceived")
            let quoteDict:NSDictionary = quote as! NSDictionary
            let quoteSymbol = quoteDict["symbol"] as! String
            let lastTradePrice = quoteDict["LastTradePriceOnly"] as! String
            let dollarGain = quoteDict["Change"] as! String
            let changeInPercentString = quoteDict["ChangeinPercent"] as! String
            
            let quoteCompanyName = quoteDict["Name"] as! String
            let previousClose = quoteDict["PreviousClose"] as! String
            let volume = quoteDict["Volume"] as! String
            let marketCap = quoteDict["MarketCapitalization"] as! String
            let peRatio = "0"
            let openPrice = quoteDict["Open"] as! String
            let averageVolume = quoteDict["AverageDailyVolume"] as! String
            let lowPriceYear = quoteDict["YearLow"] as! String
            let highPriceYear = quoteDict["YearHigh"] as! String
            
            
            //create a stock object for each stock
            let currentStock = Stock(stockTicker: quoteSymbol, stockPrice: lastTradePrice, stockGain: dollarGain, stockLow: 0, stockHigh: 0, stockCompanyName: quoteCompanyName, stockPercentGain: changeInPercentString, previousClose: previousClose, volume: volume, marketCap: marketCap, peRatio: peRatio, openPrice: openPrice, averageVolume: averageVolume, lowPriceYear: lowPriceYear, highPriceYear: highPriceYear)
            
            //create an array of stock objects
            myStocks.add(currentStock)

        }
        homeTableView.reloadData()
        NSLog("Symbols Values updated :)")
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = self.homeTableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell!
        //var (ticker, price, summary, dollargain, percentgain) = stocks[indexPath.row]
        
        let myCurrentStock: Stock = myStocks[indexPath.row] as! Stock
        
        let ticker = myCurrentStock.stockTicker
        let price = myCurrentStock.stockPrice
        let summary = myCurrentStock.stockCompanyName
        let dollargain = myCurrentStock.stockGain
        let percentgain = myCurrentStock.stockPercentGain
        
        cell.loadItem(ticker, price: price, summary: summary, dollargain: dollargain, percentgain: percentgain)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you selected #\(indexPath.row)!")
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! CustomTableViewCell!
        
        stockTickerParam = currentCell?.stockTicker.text
        stockPriceParam = currentCell?.stockPrice.text
        stockGainParam = currentCell?.stockGain.text
        print("ticker selected #\(stockTickerParam)")
        
        performSegue(withIdentifier: "StockDetailView", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "StockDetailView") {
            let viewController = segue.destination as! StockDetailViewController
            
            viewController.stockTickerSymbol = stockTickerParam
            viewController.stockPriceParam = stockPriceParam
            viewController.stockGainParam = stockGainParam
            
        }
    }
}

