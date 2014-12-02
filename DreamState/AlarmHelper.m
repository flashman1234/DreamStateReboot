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


+ (NSString *)orderedShortDayNamesFromDayArray:(NSArray *)dayArray {
    if ([dayArray count] == 7) {
        return @"Everyday";
    }
    else {
        NSArray *dayNameArray = [self dayNameArrayFromDayArray:dayArray];
        return [self orderedShortDayNamesFromArrayOfDayNames:dayNameArray];
    }
}

+ (NSArray *)dayNameArrayFromDayArray:(NSArray *)dayArray {
    NSMutableArray *dayNameArray = [[NSMutableArray alloc] init];
    for (Day *day in dayArray) {
        [dayNameArray addObject:day.day];
    }

    return dayNameArray;
}


//["Monday", "Friday", "Tuesday" etc]
+ (NSString *)orderedShortDayNamesFromArrayOfDayNames:(NSArray *)dayNameArray {
    NSString *returnString = [[NSString alloc] init];

    if ([dayNameArray count] == 7) {
        return @"Everyday";
    }
    else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSArray *weekDayArray = [[dateFormatter weekdaySymbols] mutableCopy];

        NSMutableArray *dictArray = [[NSMutableArray alloc] init];

        for (int i = 0; i < [dayNameArray count]; i++) {
            NSMutableDictionary *dict = [@{@"WeekDay" : dayNameArray[(NSUInteger) i], @"theIndex" : @([weekDayArray indexOfObject:dayNameArray[(NSUInteger) i]])} mutableCopy];
            [dictArray addObject:dict];
        }

        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"theIndex" ascending:YES];
        NSArray *descriptor = @[sortDescriptor];
        NSArray *sortedArray = [dictArray sortedArrayUsingDescriptors:descriptor];

        NSMutableArray *orderedDayNameArray = [[NSMutableArray alloc] init];

        for (NSDictionary *dictionary in sortedArray) {
            [orderedDayNameArray addObject:[dictionary valueForKey:@"WeekDay"]];
        }

        for (NSString *dayName in orderedDayNameArray) {

            NSString *shortDay = [dayName substringToIndex:3];
            returnString = [returnString stringByAppendingString:shortDay];
            returnString = [returnString stringByAppendingString:@","];
        }

        if ([returnString length] > 0) {
            returnString = [returnString substringToIndex:[returnString length] - 1];
            return returnString;
        }
        else {
            return @"";
        }
    }
}

@end