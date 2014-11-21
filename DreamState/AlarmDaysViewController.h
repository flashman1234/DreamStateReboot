//
//  AlarmDaysViewController.h
//  DreamState
//
//  Created by Michal Thompson on 18/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlarmDelegate;
@class AlarmViewController;

@interface AlarmDaysViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) NSMutableArray *selectedDayArray;

@property(nonatomic, weak) id <AlarmDelegate> delegate;

@end
