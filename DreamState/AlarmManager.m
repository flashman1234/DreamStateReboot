//
// Created by Michal Thompson on 19/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AlarmManager.h"
#import "Alarm.h"
#import "DSCoreDataContextProvider.h"
#import <CoreData/CoreData.h>


@implementation AlarmManager

- (NSArray *)getAllAlarms {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Alarm class])];
    NSError *error = nil;
    NSArray *results = [[DSCoreDataContextProvider sharedInstance].managedObjectContext executeFetchRequest:req error:&error];

    return results;
}



-(void)saveAlarmWithDate:(NSDate *)date {

    Alarm *alarm = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Alarm class])
                                                    inManagedObjectContext:[DSCoreDataContextProvider sharedInstance].managedObjectContext];

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
    NSString *timeString = [outputFormatter stringFromDate:date];

    alarm.time = timeString;

    [[DSCoreDataContextProvider sharedInstance] saveContext];


//        theDay.day = dayString;
//    }
//        [context save:nil];


//    Alarm *alarm;
//
//    if (existingAlarm) {
//        alarm = existingAlarm;
//    }
//    else {
//        alarm = [NSEntityDescription
//                insertNewObjectForEntityForName:@"Alarm"
//                         inManagedObjectContext:[self mainManagedObjectContext]];
//
//    }
//
//    [alarm setValue:alarmName forKey:@"name"];
//    [alarm setValue:alarmSound forKey:@"sound"];
//    [alarm setValue:[NSNumber numberWithBool:YES] forKey:@"enabled"];
//
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
//    NSString *timeString = [outputFormatter stringFromDate:fireDate];
//
//    [alarm setValue:timeString forKey:@"time"];
//
//    for (NSManagedObject *aDay in alarm.day) {
//        [context deleteObject:aDay];
//    }
//    NSError *saveError = nil;
//    [context save:&saveError];
//
//    for (NSString *myArrayElement in alarmRepeatDays) {
//
//        Day *day = [NSEntityDescription
//                insertNewObjectForEntityForName:@"Day"
//                         inManagedObjectContext:context];
//
//        [day setValue:myArrayElement forKey:@"day"];
//
//        [day setValue:alarm forKey:@"alarm"];
//    }
//
//
//    NSError *error;
//    if (![context save:&error]) {
//        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//    }

}

@end