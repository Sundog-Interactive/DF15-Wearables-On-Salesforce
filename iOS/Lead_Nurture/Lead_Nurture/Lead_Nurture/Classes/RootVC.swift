//
//  RootVC.swift
//  Lead_Nurture
//
//  Created by Craig Isakson on 8/24/15.
//  Copyright (c) 2015 Sundog Interactive. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    let leadHandler: LeadHandler = LeadHandler()
    
    
    //  #pragma mark - view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lead Nurture"

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleWatchKitNotification:"),
            name: "assign-campaign",
            object: nil)
    }
    
    
    
    /*
    * When we receive a notification from watch, send request for data to Salesforce Platform
    * and return information back to watch.
    */
    func handleWatchKitNotification(notification: NSNotification) {
        //do this before any handler methods.
        if let watchInfo = notification.object as? WatchInfo {
            self.leadHandler.watchInfo = watchInfo
        }
        
        
        if(notification.name == "assign-campaign") {
            self.leadHandler.assignCampaign()
            
        }
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
