//
// Created by Michal Thompson on 18/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlarmHelper : NSObject
+ (void)searchForAlarmSounds;

+ (NSString *)tidyDaysFromDayArray:(NSArray *)dayArray;

+ (NSArray *)dayNameArrayFromDayArray:(NSArray *)dayArray;

+ (NSString *)tidyDaysFromArrayOfDayNames:(NSArray *)dayNameArray;

+ (NSArray *)dayArrayFromString:(NSString *)dayString;
@end