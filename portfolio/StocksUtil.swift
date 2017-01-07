//
//  StocksUtil.swift
//  portfolio
//
//  Created by Bhavik Shah on 6/29/16.
//  Copyright © 2016 shah. All rights reserved.
//

import Foundation
import SQLite

class StocksUtil {
    
    class var sharedInstance : StocksUtil {
        struct Static {
            static let instance : StocksUtil = StocksUtil()
        }
        return Static.instance
    }

    func getUserStocks(currentUser: User) -> NSMutableArray{
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
                stock_list.addObject(stockSymbol)
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
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(65 * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), {
                self.updateStocks()
            }
        )
    }
    
    func getUserInfo() -> Void {
        print("Inside getUserInfo")
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name"])
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            }
            else {
                print("fetched user: \(result)")
                self.userName = result.valueForKey("name") as! String
                print("self.userEmail", self.userEmail)
                print("User Name is: \(self.userName)")
                self.userEmail  = result.valueForKey("email") as! String
                print("User Email is: \(self.userEmail)")
                self.userId = result.valueForKey("id") as! String
                
                let current_user = User(userName: self.userName, userEmail: self.userEmail, userId: self.userId)
                self.myStockList = self.getUserStocks(current_user)
            }
        })
        print("Finished getUserInfo")
    }
    getStockBySymbol(stockSymbol:String) -> Stock {
    // should return stock object given the symbol, how to do this?
    }
}