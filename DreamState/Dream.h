//
//  Dream.h
//  DreamState
//
//  Created by Michal Thompson on 20/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dream : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * fileUrl;
@property (nonatomic, retain) NSString * mediaType;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * time;

@end
