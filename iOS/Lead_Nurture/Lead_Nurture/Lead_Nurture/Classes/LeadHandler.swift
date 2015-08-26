//
//  LeadHandler.swift
//  Lead_Nurture
//
//  Created by Craig Isakson on 8/24/15.
//  Copyright (c) 2015 Sundog Interactive. All rights reserved.
//

import Foundation

class LeadHandler: NSObject, SFRestDelegate {
    var watchInfo : WatchInfo?
    
    func assignCampaign() {
        var sharedInstance = SFRestAPI.sharedInstance();
        var userDictionary = watchInfo?.userInfo as! Dictionary<String, String>;
        var leadId:String! = userDictionary["leadId"];
        var campaignId:String! = userDictionary["campaignId"];
        
        var fields:Dictionary<String, String> = ["LeadId": leadId, "CampaignId": campaignId];
        var request = sharedInstance.requestForCreateWithObjectType("CampaignMember", fields: fields);
        
        sharedInstance.send(request as SFRestRequest, delegate: self);
    }
    
    
    func request(request: SFRestRequest?, didLoadResponse jsonResponse: AnyObject) {
        var success = jsonResponse.objectForKey("success") as! NSArray
        
        //send the block back to the watch
        if let watchInfo = watchInfo {
            let stuff = ["success" : success]
            watchInfo.replyBlock(stuff)
        }
    }
    
    func request(request: SFRestRequest?, didFailLoadWithError error:NSError) {
        println("In Error: \(error)")
    }
    
    func requestDidCancelLoad(request: SFRestRequest) {
        println("In requestDidCancelLoad \(request)")
    }
    
    
    func requestDidTimeout(request: SFRestRequest) {
        println("In requestDidTimeout \(request)")
    }
    
    
}
