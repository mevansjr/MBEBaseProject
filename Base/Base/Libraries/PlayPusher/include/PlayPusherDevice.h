//
//  PlayPusherDevice.h
//  PlayPusher
//
//  Created by Paul Murphy on 3/22/15.
//  Copyright (c) 2015 3Advance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayPusherDevice : NSObject

typedef enum PlayPusherDevicePlatform : NSUInteger {
    
    PlayPusherDevicePlatformiOS = 1,
    PlayPusherDevicePlatformAndroid = 2
    
} PlayPusherDevicePlatformInt;

@property (nonatomic, strong) NSString* UserId;
@property (nonatomic, strong) NSString* DeviceIdentifier;
@property (nonatomic, strong) NSString* DeviceToken;
@property (nonatomic, strong) NSNumber* Platform;
@property (nonatomic, strong) NSNumber* CampaignReferralId;
@property (nonatomic, strong) NSString* DeviceName;
@property (nonatomic, strong) NSString* DeviceModel;
@property (nonatomic, strong) NSString* DeviceVersion;
@property (nonatomic, strong) NSString* AppId;
@property (nonatomic, strong) NSString* AppVersion;
@property (nonatomic, strong) NSString* SdkVersion;
@property (nonatomic, strong) NSString* Identifier;
@property (nonatomic, strong) NSMutableArray* Subscriptions;
@property (nonatomic, assign) BOOL IsProduction;
@property (nonatomic, assign) BOOL IsEnabled;

@end