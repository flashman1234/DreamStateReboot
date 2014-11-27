//
//  RecordViewController.m
//  DreamState
//
//  Created by Michal Thompson on 17/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "RecordViewController.h"
#import "Dream.h"
#import "UITextFieldNoMenu.h"
#import "RecordingImageView.h"
#import "DreamManager.h"

@interface RecordViewController ()
@property(nonatomic) BOOL autoRecord;
@property(nonatomic) BOOL isRecording;
@property(weak, nonatomic) IBOutlet UIButton *recordButton;
@property(weak, nonatomic) IBOutlet RecordingImageView *recordingImageView;
@property(weak, nonatomic) IBOutlet UITextFieldNoMenu *dreamNameTextField;
@end

@implementation RecordViewController

- (IBAction)recordButtonTouched:(id)sender {
    if (self.isRecording) {
        [self stopRecordingAudio];
        [self.recordButton setBackgroundImage:[UIImage imageNamed:@"recordIcon"] forState:UIControlStateNormal];
        [self.recordButton setNeedsLayout];
        [self.recordButton setNeedsDisplay];
    }
    else {
        [self startRecordingAudio];
        [self.recordButton setBackgroundImage:[UIImage imageNamed:@"stopIcon"] forState:UIControlStateNormal];
        [self.recordButton setNeedsLayout];
        [self.recordButton setNeedsDisplay];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
    self.dreamNameTextField.rightViewMode = UITextFieldViewModeAlways;
    self.dreamNameTextField.text = self.dream.name;
    self.dreamNameTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self getUserDefaults];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.segmentedControl.selectedSegmentIndex = -1;
    [super viewWillAppear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    self.dream.name = self.dreamNameTextField.text;
    DreamManager *manager = [[DreamManager alloc] init];
    [manager saveDream:self.dream];
    [theTextField resignFirstResponder];
    [self.tabBarController setSelectedIndex:2];
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.autoRecord) {
        self.segmentedControl.selectedSegmentIndex = 0;
        [self startRecordingAudio];
    }
    else {
        self.dreamNameTextField.hidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    if (self.isRecording) {
        [self stopRecordingAudio];
    }

    if (self.mediaPlayer) {
        [self.mediaPlayer stop];
        [self.mediaPlayer.view removeFromSuperview];
        self.mediaPlayer = nil;
    }

    self.isRecording = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)iTextField {
    [iTextField selectAll:self];
}

#pragma mark - Record and play video

- (void)playDream {

}

- (void)levelTimerCallback:(NSTimer *)timer {
    if (self.isRecording) {
        [self.aVAudioRecorder updateMeters];

        const double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (0.05 * [self.aVAudioRecorder peakPowerForChannel:0]));
        self.lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * self.lowPassResults;
        self.recordingImageView.passedInValue = (CGFloat) self.lowPassResults;
        [self.recordingImageView setNeedsDisplay];
        [self.recordingImageView updateConstraints];
        [self.recordingImageView layoutIfNeeded];
    }
}

- (void)startRecordingAudio {
    if (self.mediaPlayer) {
        [self.mediaPlayer stop];
        [self.mediaPlayer.view removeFromSuperview];
    }

    self.dreamNameTextField.hidden = YES;
    self.isRecording = YES;
    self.fileURL = [NSURL fileURLWithPath:[self createFileName:@"caf"]];

    self.recordSettings = @{AVFormatIDKey : @(kAudioFormatAppleIMA4),
            AVSampleRateKey : @16000,
            AVNumberOfChannelsKey : @1,
            AVLinearPCMBitDepthKey : @16,
            AVLinearPCMIsBigEndianKey : @NO,
            AVLinearPCMIsFloatKey : @NO};
    NSError *error = nil;

    self.aVAudioRecorder = [[AVAudioRecorder alloc]
            initWithURL:self.fileURL
               settings:self.recordSettings
                  error:&error];
    if (error) {
        NSLog(@"[AVAudioRecorder alloc] error: %@", [error localizedDescription]);
    }
    else {
        self.aVAudioRecorder.meteringEnabled = YES;
        [self.aVAudioRecorder prepareToRecord];
        [self.aVAudioRecorder record];

        [self createDreamObjectAndSave];
    }
}

- (void)createDreamObjectAndSave {
    DreamManager *manager = [[DreamManager alloc] init];
    self.dream = [manager createNewDream];

    NSDateFormatter *dreamDateFormatter = [[NSDateFormatter alloc] init];
    [dreamDateFormatter setDateFormat:@"dd MMM yyyy"];

    NSString *dreamDateAsString = [dreamDateFormatter stringFromDate:[NSDate date]];

    NSDateFormatter *dreamTimeFormatter = [[NSDateFormatter alloc] init];
    [dreamTimeFormatter setDateFormat:@"HH:mm"];

    NSString *dreamTimeAsString = [dreamTimeFormatter stringFromDate:[NSDate date]];

    self.dream.name = [dreamDateAsString stringByAppendingString:@""];
    self.dream.fileUrl = self.fileName;
    self.dream.date = dreamDateAsString;
    self.dream.mediaType = @"Audio";
    self.dream.dateCreated = [NSDate date];
    self.dream.time = dreamTimeAsString;
    [manager saveDream:self.dream];
}

- (void)stopRecordingAudio {
    self.dreamNameTextField.hidden = NO;
    [self.dreamNameTextField becomeFirstResponder];
    self.isRecording = NO;
    [self.aVAudioRecorder stop];
    [self playDream];
}

#pragma mark - view methods

- (void)getUserDefaults {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.autoRecord = [self.userDefaults boolForKey:@"AutoRecord"];
}

#pragma mark - file handlers

- (NSString *)createFileName:(NSString *)fileType {
    NSArray *documentDirectoryPaths;
    NSString *documentDirectory;

    documentDirectoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDirectory = documentDirectoryPaths[0];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyyHHmmss"];
    NSString *theFileName = [NSString stringWithFormat:@"%@.%@", [formatter stringFromDate:[NSDate date]], fileType];
    NSString *fullFilePath = [documentDirectory stringByAppendingPathComponent:theFileName];
    NSLog(@"fullFilePath = %@", fullFilePath);

    self.fileName = theFileName;
    return fullFilePath;
}

@end
