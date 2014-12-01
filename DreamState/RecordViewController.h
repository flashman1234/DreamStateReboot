//
//  RecordViewController.h
//  DreamState
//
//  Created by Michal Thompson on 17/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EZMicrophone.h"


@class Dream;
@class UITextFieldNoMenu;
@class EZMicrophone;
@class EZRecorder;

@interface RecordViewController : UIViewController <UITextFieldDelegate, EZMicrophoneDelegate>

@property(nonatomic, retain) NSUserDefaults *userDefaults;
@property(nonatomic, retain) Dream *dream;
@property(nonatomic, retain) NSURL *fileURL;
@property(nonatomic, retain) NSString *fileName;

@property (nonatomic,strong) EZMicrophone *microphone;
@property (nonatomic,strong) EZRecorder *recorder;





@end
