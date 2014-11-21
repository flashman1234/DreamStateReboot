//
//  Alarm.h
//  DreamState
//
//  Created by Michal Thompson on 20/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day;

@interface Alarm : NSManagedObject

@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sound;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSSet *day;
@end

@interface Alarm (CoreDataGeneratedAccessors)

- (void)addDayObject:(Day *)value;
- (void)removeDayObject:(Day *)value;
- (void)addDay:(NSSet *)values;
- (void)removeDay:(NSSet *)values;

@end
