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
#import "ZLSinusWaveView.h"
#import "EZRecorder.h"

@interface RecordViewController ()
@property(nonatomic) BOOL autoRecord;
@property(nonatomic) BOOL isRecording;
@property(weak, nonatomic) IBOutlet UIButton *recordButton;
@property(weak, nonatomic) IBOutlet ZLSinusWaveView *audioPlot;
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
    self.dreamNameTextField.rightViewMode = UITextFieldViewModeAlways;
    self.dreamNameTextField.text = self.dream.name;
    self.dreamNameTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self getUserDefaults];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];

    self.microphone = [EZMicrophone microphoneWithDelegate:self];

    /*
   Customizing the audio plot's look
   */
    // Background color
    self.audioPlot.backgroundColor = [UIColor blackColor];
    // Waveform color
    self.audioPlot.color = [UIColor whiteColor];
    // Plot type
    self.audioPlot.plotType = EZPlotTypeRolling;
    // Fill
    self.audioPlot.shouldFill = YES;
    // Mirror
    self.audioPlot.shouldMirror = YES;
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

//    if (self.mediaPlayer) {
//        [self.mediaPlayer stop];
//        [self.mediaPlayer.view removeFromSuperview];
//        self.mediaPlayer = nil;
//    }

    self.isRecording = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)iTextField {
    [iTextField selectAll:self];
}

#pragma mark - Record and play audio

- (void)startRecordingAudio {
    self.dreamNameTextField.hidden = YES;
    self.isRecording = YES;
    self.fileURL = [NSURL fileURLWithPath:[self createFileName:@"caf"]];

    [self.microphone startFetchingAudio];

    self.recorder = [EZRecorder recorderWithDestinationURL:self.fileURL
                                              sourceFormat:self.microphone.audioStreamBasicDescription
                                       destinationFileType:EZRecorderFileTypeM4A];
    [self createDreamObjectAndSave];
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

    [self.microphone stopFetchingAudio];
    [self.recorder closeAudioFile];
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


#pragma mark - EZMicrophoneDelegate
#warning Thread Safety

// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
- (void)microphone:(EZMicrophone *)microphone
  hasAudioReceived:(float **)buffer
      withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.

    // See the Thread Safety warning above, but in a nutshell these callbacks happen on a separate audio thread. We wrap any UI updating in a GCD block on the main thread to avoid blocking that audio flow.
    dispatch_async(dispatch_get_main_queue(), ^{
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
    });
}

- (void)microphone:(EZMicrophone *)microphone
     hasBufferList:(AudioBufferList *)bufferList
      withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {

    // Getting audio data as a buffer list that can be directly fed into the EZRecorder. This is happening on the audio thread - any UI updating needs a GCD main queue block. This will keep appending data to the tail of the audio file.
    if (self.isRecording) {
        [self.recorder appendDataFromBufferList:bufferList
                                 withBufferSize:bufferSize];
    }

}

@end
