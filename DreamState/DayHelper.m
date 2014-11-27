//
//  DayHelper.m
//  DreamState
//
//  Created by Michal Thompson on 27/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "DayHelper.h"

@implementation DayHelper

+ (NSArray *)reorderSelectedDaysArray:(NSArray *)dayArray {
    NSMutableArray *dictArray = [[NSMutableArray alloc] init];

    for (int i = 0; i < [dayArray count]; i++) {
        NSMutableDictionary *dict = [@{@"WeekDay" : dayArray[(NSUInteger) i], @"theIndex" : @([dayArray indexOfObject:dayArray[(NSUInteger) i]])} mutableCopy];
        [dictArray addObject:dict];
    }

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"theIndex" ascending:YES];
    NSArray *descriptor = @[sortDescriptor];
    NSArray *sortedArray = [dictArray sortedArrayUsingDescriptors:descriptor];

    NSMutableArray *finalArray = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in sortedArray) {
        [finalArray addObject:[dictionary valueForKey:@"WeekDay"]];
    }
    return finalArray;
}

@end
