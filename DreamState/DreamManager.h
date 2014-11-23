//
// Created by Michal Thompson on 23/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dream;


@interface DreamManager : NSObject

-(Dream *)createNewDream;
-(void)saveDream:(Dream *)dream;

- (NSArray *)getAllDreams;


@end