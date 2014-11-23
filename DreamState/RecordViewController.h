//
//  RecordViewController.h
//  DreamState
//
//  Created by Michal Thompson on 17/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AVFoundation"
#import <MediaPlayer/MediaPlayer.h>


@class Dream;
@class AVAudioRecorder;
@class UITextFieldNoMenu;
@class RecordingImageView;

@class MPMoviePlayerController;

@interface RecordViewController : UIViewController <UITextFieldDelegate>

-(void)levelTimerCallback:(NSTimer *)timer;

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, retain) NSString *audioOrVideo;
@property (nonatomic, retain) NSDictionary *recordSettings;
@property (nonatomic, retain) Dream *dream;
@property (nonatomic, retain) AVAudioRecorder *aVAudioRecorder;
@property (nonatomic, retain) NSURL  *fileURL;

@property (nonatomic, retain) MPMoviePlayerController *mediaPlayer;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) UIView *overlayView;

//@property (nonatomic, retain) DIYCam *diyCam;
//@property BOOL loadedFromAlarm;
@property (nonatomic, retain) UIImage *isRecordingImage;
@property (nonatomic, retain) UIImageView *isRecordingImageView;
@property (nonatomic, retain) RecordingImageView *sineWaveView;
@property (nonatomic, retain) UIImageView *sineWaveImageView;
@property (nonatomic, retain) NSTimer *levelTimer;
@property double lowPassResults;


@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UITextFieldNoMenu *dreamNameTextField;

@end
