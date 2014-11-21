//
// Created by Michal Thompson on 20/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "CoreDataManager.h"
#import "Alarm.h"
#import "DSCoreDataContextProvider.h"


@implementation CoreDataManager

- (id)insertCoreDataObjectWithClassName:(NSString *)className {
    return [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[DSCoreDataContextProvider sharedInstance].managedObjectContext];
}

@end