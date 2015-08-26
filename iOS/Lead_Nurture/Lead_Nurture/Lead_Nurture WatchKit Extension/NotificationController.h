//
//  NotificationController.h
//  Watchkit_Example WatchKit Extension
//
//  Created by Craig Isakson on 8/11/15.
//  Copyright (c) 2015 Sundog Interactive. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface NotificationController : WKUserNotificationInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelLeadName;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *labelLeadDescription;

@end
