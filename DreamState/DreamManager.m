//
// Created by Michal Thompson on 23/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "DreamManager.h"
#import "Dream.h"
#import "CoreDataManager.h"
#import "DSCoreDataContextProvider.h"


@implementation DreamManager
- (Dream *)createNewDream {

    CoreDataManager *manager = [[CoreDataManager alloc] init];
    Dream *dream = [manager insertCoreDataObjectWithClassName:NSStringFromClass([Dream class])];

    return dream;
}

- (void)saveDream:(Dream *)dream {
    [[DSCoreDataContextProvider sharedInstance] saveContext];
}

- (NSArray *)getAllDreams {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Dream class])];
    NSError *error = nil;
    NSArray *results = [[DSCoreDataContextProvider sharedInstance].managedObjectContext executeFetchRequest:req error:&error];

    return results;
}

- (NSArray *)getAllDreamsWithMostRecentFirst {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Dream class])];

    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO];
    [req setSortDescriptors:@[dateSort]];

    NSError *error = nil;
    NSArray *results = [[DSCoreDataContextProvider sharedInstance].managedObjectContext executeFetchRequest:req error:&error];

    return results;
}

@end