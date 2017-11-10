//
//  PlayPusher.h
//  PlayPusher
//
//  Created by Paul Murphy on 7/29/14.
//  Copyright (c) 2014 3Advance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayPusherSubscription.h"
#import "PlayPusherDevice.h"

@interface PlayPusher : NSObject

+ (PlayPusher *)sharedInstance;

- (BOOL)initWithApplicationKey:(NSString*)applicationKey;
- (BOOL)initPlayPusher:(NSString*)deviceIdentifier withClientId:(NSString*)clientId withClientSecret:(NSString*)clientSecret;
- (BOOL)initPlayPusher:(NSString*)deviceIdentifier withClientId:(NSString*)clientId withClientSecret:(NSString*)clientSecret withUserId:(NSString*)userId;
- (void)requestPermission:(NSString*)userId;
- (void)requestPermission:(NSString*)userId withCategories:(NSSet*)categories;
- (BOOL)registerDevice:(NSData*)deviceToken;
- (BOOL)registerFailure;
- (void)updateCampaignReferralId:(NSNumber*)campaignReferralId;
- (void)updateUserId:(NSString*)userId;
- (void)getSubscriptions:(void (^)(NSArray *subscriptions))completion;
- (void)getReferralLink:(void (^)(NSURL *linkUrl))completion;
- (void)getReferralLink:(NSString*)userId withSuccess:(void (^)(NSURL *linkUrl))completion;
- (void)saveSubscription:(PlayPusherSubscription*)subscription withSuccess:(void (^)(NSString *status))completion;
- (BOOL)checkNotificationState;

- (void)addAction:(void (^)(NSArray* ids))blk forPathComponents:(NSArray*)components;
- (void)addAction:(void (^)(NSString* value))blk forPathComponent:(NSString*)component;
- (BOOL)handleOpenURL:(NSURL*)url;
- (void)handleNotification:(NSDictionary *)userInfo;

- (void)saveRegisterConversion;
- (void)saveOpenConversion;
- (void)saveOpenConversionWithValue:(NSString*)value;
- (void)saveCustomConversion:(NSString*)conversionName withValue:(NSString*)value;
- (void)savePromoConversionWithValue:(NSString*)value withSuccess:(void (^)(NSString* path, NSError* error))completion;

@property (nonatomic, strong) NSString* applicationKey;
@property (nonatomic, assign) BOOL sandboxMode;

@end
