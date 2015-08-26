//
//  WatchInfo.swift
//  Lead_Nurture
//
//  Created by Craig Isakson on 8/24/15.
//  Copyright (c) 2015 Sundog Interactive. All rights reserved.
//

import Foundation


class WatchInfo: NSObject, SFRestDelegate {
    
    var userInfo: [NSObject : AnyObject]!
    
    let replyBlock: ([NSObject : AnyObject]!) -> Void
    
    
    init(userInfo: [NSObject : AnyObject], reply: ([NSObject : AnyObject]!) -> Void) {
        
        self.userInfo = userInfo
        replyBlock = reply
    }
    
}
