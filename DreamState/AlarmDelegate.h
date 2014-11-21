//
// Created by Michal Thompson on 20/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlarmDelegate <NSObject>

@optional
- (void)setAlarmDaysWithDayNameArray:(NSArray *)dayArray;

- (void)setAlarmSoundWithSoundName:(NSString *)soundName;

@end