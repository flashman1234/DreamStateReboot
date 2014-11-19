//
//  Day.h
//  DreamState
//
//  Created by Michal Thompson on 19/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Alarm;

@interface Day : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) Alarm *alarm;

@end
