//
// Created by Michal Thompson on 18/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlarmHelper : NSObject
+ (void)searchForAlarmSounds;

+ (NSString *)orderedShortDayNamesFromDayArray:(NSArray *)dayArray;

+ (NSArray *)dayNameArrayFromDayArray:(NSArray *)dayArray;

+ (NSString *)orderedShortDayNamesFromArrayOfDayNames:(NSArray *)dayNameArray;

//+ (NSArray *)dayArrayFromString:(NSString *)dayString;
//
//+ (NSString *)tidyDaysFromArrayOfDayDictionary:(NSArray *)dayDictionaryArray;
@end