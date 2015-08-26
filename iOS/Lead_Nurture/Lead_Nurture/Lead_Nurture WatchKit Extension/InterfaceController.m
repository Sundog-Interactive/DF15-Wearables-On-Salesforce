//
//  InterfaceController.m
//  Watchkit_Example WatchKit Extension
//
//  Created by Craig Isakson on 8/11/15.
//  Copyright (c) 2015 Sundog Interactive. All rights reserved.
//

#import "InterfaceController.h"
#import "CampaignRowView.h"


@interface InterfaceController()
@property (strong, nonatomic) NSDictionary* recievedNotification;

@end


@implementation InterfaceController
@synthesize labelTitle, tableCampaigns, recievedNotification;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    NSLog(@"in awakeWithContext");
}


- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void) handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)remoteNotification{
    NSLog(@"handle action");
    
    self.recievedNotification = remoteNotification;
    NSArray* campaigns = [self.recievedNotification objectForKey:@"campaigns"];
    
    [tableCampaigns setNumberOfRows:[campaigns count] withRowType:@"campaignRow"];
    
    int i;
    for (i = 0; i < [campaigns count]; i++) {
        CampaignRowView* row = [tableCampaigns rowControllerAtIndex:i];
        [row.labelTitle setText:[[campaigns objectAtIndex:i] objectForKey:@"campaignName"]];
    }
}


-(id) contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex{
    
    if([segueIdentifier isEqualToString:@"campaignSelected"]){
        NSMutableDictionary* returnDict = [[NSMutableDictionary alloc] init];
        
        [returnDict addEntriesFromDictionary:[[self.recievedNotification objectForKey:@"campaigns"] objectAtIndex:rowIndex]];
        [returnDict setObject:[self.recievedNotification objectForKey:@"leadId"] forKeyedSubscript:@"leadId"];
        return returnDict;
    }
    
    
    return nil;
}

@end



