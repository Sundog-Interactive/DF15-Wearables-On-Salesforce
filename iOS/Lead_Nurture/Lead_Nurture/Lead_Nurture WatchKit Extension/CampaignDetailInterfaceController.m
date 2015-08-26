//
//  CampaignDetailInterfaceController.m
//  Watchkit_Example
//
//  Created by Craig Isakson on 8/19/15.
//  Copyright (c) 2015 Sundog Interactive. All rights reserved.
//

#import "CampaignDetailInterfaceController.h"

@interface CampaignDetailInterfaceController ()


@end

@implementation CampaignDetailInterfaceController
@synthesize labelInformation;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    if([context isKindOfClass:[NSMutableDictionary class]]){
        [self.labelInformation setText:@"Updating..."];
        
        NSDictionary *request = @{ @"request-type" : @"assign-campaign", @"campaignId" : [context objectForKey:@"campaignId"], @"leadId" : [context objectForKey:@"leadId"] };
        
        [WKInterfaceController openParentApplication:request
                                               reply:^( NSDictionary *replyInfo, NSError *error ) {
                                                   NSLog(@"in reply from openParentApplication");
                                                   
                                                   [self.labelInformation setText:@"Success!"];
                                               }];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



