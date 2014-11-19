//
//  DSCoreDataContextProvider.h
//  DreamState
//
//  Created by Michal Thompson on 19/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface DSCoreDataContextProvider : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedInstance;

- (void)saveContext;
@end
