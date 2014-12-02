//
// Created by Michal Thompson on 24/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Alarm;
@class MuteChecker;


@interface NotificationManager : NSObject

@property(nonatomic, strong) NSArray *alarms;
@property NSInteger numberOfAlarms;
@property(nonatomic, strong) MuteChecker *muteChecker;

- (void)loadNotifications;

- (void)createNotificationForAlarm:(Alarm *)alarm;

@end