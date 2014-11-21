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

@end