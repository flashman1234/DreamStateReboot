//
// Created by Michal Thompson on 19/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Alarm;

@interface AlarmManager : NSObject

- (NSArray *)getAllAlarms;

- (NSArray *)getAllActiveAlarms;

- (void)saveAlarmWithName:(NSString *)name date:(NSDate *)date fullNameDayArray:(NSArray *)fullNameDayArray sound:(NSString *)sound;

- (void)updateAlarm:(Alarm *)alarm name:(NSString *)name date:(NSDate *)date fullNameDayArray:(NSArray *)fullNameDayArray sound:(NSString *)sound enabled:(BOOL)enabled;

- (void)deleteAlarm:(Alarm *)alarm;

@end