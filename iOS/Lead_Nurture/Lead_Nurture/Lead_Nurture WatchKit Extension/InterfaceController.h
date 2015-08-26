//
//  InterfaceController.h
//  Watchkit_Example WatchKit Extension
//
//  Created by Craig Isakson on 8/11/15.
//  Copyright (c) 2015 Sundog Interactive. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelTitle;
@property (weak, nonatomic) IBOutlet WKInterfaceTable *tableCampaigns;

@end
