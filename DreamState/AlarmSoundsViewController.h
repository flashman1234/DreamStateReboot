//
//  AlarmSoundsViewController.h
//  DreamState
//
//  Created by Michal Thompson on 18/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmViewController.h"

@interface AlarmSoundsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak) id <AlarmDelegate> delegate;
@end
