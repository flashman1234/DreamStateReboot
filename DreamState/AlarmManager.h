//
// Created by Michal Thompson on 19/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlarmManager : NSObject

-(NSArray *)getAllAlarms;

-(void)saveAlarmWithDate:(NSDate *)date;


@end