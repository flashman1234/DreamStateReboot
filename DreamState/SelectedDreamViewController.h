//
//  SelectedDreamViewController.h
//  DreamState
//
//  Created by Michal Thompson on 26/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudioFile.h"
#import "EZOutput.h"

@class Dream;

@interface SelectedDreamViewController : UIViewController <EZAudioFileDelegate, EZOutputDataSource, UITextFieldDelegate>

@property (nonatomic) Dream *selectedDream;
@end
