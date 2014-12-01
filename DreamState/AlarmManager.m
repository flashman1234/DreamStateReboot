//
// Created by Michal Thompson on 19/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AlarmManager.h"
#import "Alarm.h"
#import "DSCoreDataContextProvider.h"
#import "Day.h"
#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

@implementation AlarmManager

- (NSArray *)getAllAlarms {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Alarm class])];
    NSError *error = nil;
    NSArray *results = [[DSCoreDataContextProvider sharedInstance].managedObjectContext executeFetchRequest:req error:&error];

    return results;
}

- (NSArray *)getAllActiveAlarms {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Alarm class])];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"enabled == YES"];
    [req setPredicate:predicate];

    NSError *error = nil;
    NSArray *results = [[DSCoreDataContextProvider sharedInstance].managedObjectContext executeFetchRequest:req error:&error];

    return results;
}

- (void)saveAlarmWithName:(NSString *)name date:(NSDate *)date fullNameDayArray:(NSArray *)fullNameDayArray sound:(NSString *)sound {
    CoreDataManager *manager = [[CoreDataManager alloc] init];
    Alarm *alarm = [manager insertCoreDataObjectWithClassName:NSStringFromClass([Alarm class])];

    [self updateAlarm:alarm name:name date:date fullNameDayArray:fullNameDayArray sound:sound enabled:YES];
}

- (void)updateAlarm:(Alarm *)alarm name:(NSString *)name date:(NSDate *)date fullNameDayArray:(NSArray *)fullNameDayArray sound:(NSString *)sound enabled:(BOOL)enabled {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
    NSString *timeString = [outputFormatter stringFromDate:date];

    alarm.name = name;
    alarm.time = timeString;

    for (NSManagedObject *aDay in alarm.day) {
        [[DSCoreDataContextProvider sharedInstance].managedObjectContext deleteObject:aDay];
    }

    for (NSString *dayName in fullNameDayArray) {
        Day *aDay = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Day class])
                                                  inManagedObjectContext:[DSCoreDataContextProvider sharedInstance].managedObjectContext];
        aDay.day = dayName;
        aDay.alarm = alarm;
    }

    alarm.sound = sound;
    alarm.enabled = @(enabled);

    [[DSCoreDataContextProvider sharedInstance] saveContext];
}

@end