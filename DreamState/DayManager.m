//
// Created by Michal Thompson on 19/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "DayManager.h"
#import "DSCoreDataContextProvider.h"
#import "Day.h"
#import <CoreData/CoreData.h>

@implementation DayManager

- (NSArray *)getAllDays {

    DSCoreDataContextProvider *provider = [DSCoreDataContextProvider sharedInstance];
    NSManagedObjectContext *context = provider.managedObjectContext;

    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Day class])];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:req error:&error];

    return results;
}

//- (void)loadInitialDays {
//    DSCoreDataContextProvider *provider = [DSCoreDataContextProvider sharedInstance];
//    NSManagedObjectContext *context = provider.managedObjectContext;
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSArray *dayArray = [[dateFormatter weekdaySymbols] mutableCopy];
//
//    for (NSString *dayString in dayArray) {
//        Day *theDay = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Day class])
//                                                    inManagedObjectContext:context];
//        theDay.day = dayString;
//    }
//        [context save:nil];
//
//
//}
@end