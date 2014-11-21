//
// Created by Michal Thompson on 18/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AppDelegate.h"
#import "AlarmHelper.h"
#import "Day.h"

@implementation AlarmHelper

+ (void)searchForAlarmSounds {
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:bundleRoot];

    NSMutableArray *alarmSoundsArray = [[NSMutableArray alloc] init];

    NSString *filename;

    while ((filename = [direnum nextObject])) {
        if ([filename hasSuffix:@".m4a"]) {
            [alarmSoundsArray addObject:[filename stringByDeletingPathExtension]];
        }
    }

    [[NSUserDefaults standardUserDefaults] setObject:alarmSoundsArray forKey:@"alarmSoundsArray"];
}

+ (NSString *)tidyDaysFromDayArray:(NSArray *)dayArray {
    NSString *tidyDay = [[NSString alloc] init];

    if ([dayArray count] == 7) {
        return @"Everyday";
    }

    for (Day *day in dayArray) {

        NSString *shortDay = [day.day substringToIndex:3];

        tidyDay = [tidyDay stringByAppendingString:shortDay];
        tidyDay = [tidyDay stringByAppendingString:@","];
    }

    if ([tidyDay length] > 0) {
        tidyDay = [tidyDay substringToIndex:[tidyDay length] - 1];
        return tidyDay;
    }
    else {
        return @"";
    }
}

+ (NSArray *)dayNameArrayFromDayArray:(NSArray *)dayArray {
    NSMutableArray *dayNameArray = [[NSMutableArray alloc] init];
    for (Day *day in dayArray) {
        [dayNameArray addObject:day.day];
    }

    return dayNameArray;
}

+ (NSString *)tidyDaysFromArrayOfDayNames:(NSArray *)dayNameArray {
    NSString *tidyDay = [[NSString alloc] init];

    if ([dayNameArray count] == 7) {
        return @"Everyday";
    }

    for (NSString *dayName in dayNameArray) {

        NSString *shortDay = [dayName substringToIndex:3];

        tidyDay = [tidyDay stringByAppendingString:shortDay];
        tidyDay = [tidyDay stringByAppendingString:@","];
    }

    if ([tidyDay length] > 0) {
        tidyDay = [tidyDay substringToIndex:[tidyDay length] - 1];
        return tidyDay;
    }
    else {
        return @"";
    }
}


+ (NSArray *)dayArrayFromString:(NSString *)dayString {

    NSArray *shortDayArray = [dayString componentsSeparatedByString:@","];
    NSMutableArray *longDayArray = [[NSMutableArray alloc] init];

    for (NSString *shortDay in shortDayArray) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEEE";
        [longDayArray addObject:[formatter dateFromString:shortDay]];
    }

    return longDayArray;
}

@end