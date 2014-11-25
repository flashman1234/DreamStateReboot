//
// Created by Michal Thompson on 24/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Alarm;


@interface NotificationManager : NSObject

-(void)loadNotifications;
-(void)createNotificationForAlarm:(Alarm *)alarm;

@property (nonatomic, strong) NSArray *alarms;
@property (nonatomic, strong) NSArray *notificationArray;
@property int numberOfAlarms;

@end