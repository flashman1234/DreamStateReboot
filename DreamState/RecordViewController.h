//
//  RecordViewController.h
//  DreamState
//
//  Created by Michal Thompson on 17/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@class Dream;
@class AVAudioRecorder;
@class UITextFieldNoMenu;
@class RecordingImageView;

@class MPMoviePlayerController;

@interface RecordViewController : UIViewController <UITextFieldDelegate>

- (void)levelTimerCallback:(NSTimer *)timer;

@property(nonatomic, retain) NSUserDefaults *userDefaults;
@property(nonatomic, retain) NSDictionary *recordSettings;
@property(nonatomic, retain) Dream *dream;
@property(nonatomic, retain) AVAudioRecorder *aVAudioRecorder;
@property(nonatomic, retain) NSURL *fileURL;
@property(nonatomic, retain) NSString *fileName;
@property(nonatomic, retain) MPMoviePlayerController *mediaPlayer;
@property double lowPassResults;
@property(nonatomic, retain) UISegmentedControl *segmentedControl;

@end
