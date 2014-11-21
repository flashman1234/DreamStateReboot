//
//  AlarmViewController.h
//  DreamState
//
//  Created by Michal Thompson on 17/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmDelegate.h"

@class Alarm;

@interface AlarmViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, AlarmDelegate>

@property(nonatomic) Alarm *existingAlarm;

@end


