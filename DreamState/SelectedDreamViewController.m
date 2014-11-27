//
//  SelectedDreamViewController.m
//  DreamState
//
//  Created by Michal Thompson on 26/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "SelectedDreamViewController.h"
#import "Dream.h"
#import "EZAudioPlotGL.h"
#import "EZAudio.h"
#import "ZLSinusWaveView.h"
#import "CSAnimationView.h"
#import "DreamManager.h"

@interface SelectedDreamViewController ()
@property(weak, nonatomic) IBOutlet ZLSinusWaveView *audioPlot;
@property(weak, nonatomic) IBOutlet UIButton *playButton;
@property(nonatomic, strong) EZAudioFile *audioFile;
@property(nonatomic, weak) IBOutlet UISlider *framePositionSlider;
@property(weak, nonatomic) IBOutlet UIView *sliderAnimationView;
@property(weak, nonatomic) IBOutlet UITextField *dreamNameTextField;
@property(nonatomic, assign) BOOL eof;
@end

@implementation SelectedDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
   Customizing the audio plot's look
   */
    // Background color
    self.audioPlot.backgroundColor = [UIColor blackColor];
    // Waveform color
    self.audioPlot.color = [UIColor whiteColor];
    // Plot type
    self.audioPlot.plotType = EZPlotTypeBuffer;
    // Fill
    self.audioPlot.shouldFill = NO;
    // Mirror
    self.audioPlot.shouldMirror = NO;

    NSArray *documentDirectoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentDirectoryPaths[0];
    NSURL *fullPath = [NSURL fileURLWithPath:[documentDirectory stringByAppendingPathComponent:self.selectedDream.fileUrl]];

    [self openFileWithFilePathURL:fullPath];
    self.dreamNameTextField.text = self.selectedDream.name;
    self.dreamNameTextField.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [EZOutput sharedOutput].outputDataSource = nil;
    [[EZOutput sharedOutput] stopPlayback];
}

- (void)openFileWithFilePathURL:(NSURL *)filePathURL {
    // Stop playback
    [[EZOutput sharedOutput] stopPlayback];

    self.audioFile = [EZAudioFile audioFileWithURL:filePathURL];
    self.audioFile.audioFileDelegate = self;
    self.eof = NO;
    self.framePositionSlider.maximumValue = (float) self.audioFile.totalFrames;

    // Set the client format from the EZAudioFile on the output
    [[EZOutput sharedOutput] setAudioStreamBasicDescription:self.audioFile.clientFormat];

    // Plot the whole waveform
    self.audioPlot.plotType = EZPlotTypeBuffer;
    self.audioPlot.shouldFill = YES;
    self.audioPlot.shouldMirror = YES;
    [self.audioFile getWaveformDataWithCompletionBlock:^(float *waveformData, UInt32 length) {
        [self.audioPlot updateBuffer:waveformData withBufferSize:length];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    self.selectedDream.name = self.dreamNameTextField.text;
    DreamManager *manager = [[DreamManager alloc] init];
    [manager saveDream:self.selectedDream];
    [self.dreamNameTextField resignFirstResponder];
    return YES;
}

#pragma mark - EZAudioFileDelegate

- (void)audioFile:(EZAudioFile *)audioFile
        readAudio:(float **)buffer
      withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([EZOutput sharedOutput].isPlaying) {
            if (self.audioPlot.plotType == EZPlotTypeBuffer &&
                    self.audioPlot.shouldFill &&
                    self.audioPlot.shouldMirror) {
                self.audioPlot.shouldFill = NO;
                self.audioPlot.shouldMirror = NO;
            }
            [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
        }
    });
}

- (void)audioFile:(EZAudioFile *)audioFile
  updatedPosition:(SInt64)framePosition {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.framePositionSlider.touchInside) {
            self.framePositionSlider.value = (float) framePosition;
        }
    });
}

#pragma mark - EZOutputDataSource

- (void)output:(EZOutput *)output shouldFillAudioBufferList:(AudioBufferList *)audioBufferList withNumberOfFrames:(UInt32)frames {
    if (self.audioFile) {
        UInt32 bufferSize;
        [self.audioFile readFrames:frames
                   audioBufferList:audioBufferList
                        bufferSize:&bufferSize
                               eof:&_eof];
        if (_eof) {
            [[EZOutput sharedOutput] stopPlayback];
            [EZOutput sharedOutput].outputDataSource = nil;
        }
    }
}

- (void)seekToFrame:(id)sender {
    [self.audioFile seekToFrame:(SInt64) [(UISlider *) sender value]];
}

- (IBAction)playButtonTouched:(id)sender {
    [self.sliderAnimationView startCanvasAnimation];

    if (![[EZOutput sharedOutput] isPlaying]) {
        if (self.eof) {
            [self.audioFile seekToFrame:0];
        }
        [EZOutput sharedOutput].outputDataSource = self;
        [[EZOutput sharedOutput] startPlayback];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pauseIcon"] forState:UIControlStateNormal];
    }
    else {
        [EZOutput sharedOutput].outputDataSource = nil;
        [[EZOutput sharedOutput] stopPlayback];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
    }
}

@end
