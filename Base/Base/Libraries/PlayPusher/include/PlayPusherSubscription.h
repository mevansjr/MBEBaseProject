//
//  PlayPusherSubscription.h
//  PlayPusher
//
//  Created by Paul Murphy on 3/22/15.
//  Copyright (c) 2015 3Advance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayPusherSubscription : NSObject

@property (nonatomic, strong) NSNumber* SubscriptionId;
@property (nonatomic, strong) NSNumber* NotificationId;
@property (nonatomic, strong) NSString* UserId;
@property (nonatomic, strong) NSNumber* Channel;
@property (nonatomic, strong) NSString* Title;
@property (nonatomic, strong) NSString* Description;
@property (nonatomic, strong) NSString* CreatedDate;

@end
