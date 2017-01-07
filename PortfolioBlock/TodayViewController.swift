//
//  TodayViewController.swift
//  PortfolioBlock
//
//  Created by Bhavik Shah on 2/15/16.
//  Copyright (c) 2016 shah. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var labelWidget: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        DispatchQueue.main.async(execute: {
            self.labelWidget.text = "AAPL +3.3%"
        });
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
