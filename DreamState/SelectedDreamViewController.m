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

@interface SelectedDreamViewController ()
@property(weak, nonatomic) IBOutlet ZLSinusWaveView *audioPlot;
@property(weak, nonatomic) IBOutlet UIButton *playButton;
@property(nonatomic, strong) EZAudioFile *audioFile;
@property(nonatomic, weak) IBOutlet UISlider *framePositionSlider;
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
//    self.filePathLabel.text               = filePathURL.lastPathComponent;
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
//            [self seekToFrame:0];
        }
    }
}

- (void)seekToFrame:(id)sender {
    [self.audioFile seekToFrame:(SInt64) [(UISlider *) sender value]];
}

- (IBAction)playButtonTouched:(id)sender {

    if (![[EZOutput sharedOutput] isPlaying]) {
        if (self.eof) {
            [self.audioFile seekToFrame:0];
        }
        [EZOutput sharedOutput].outputDataSource = self;
        [[EZOutput sharedOutput] startPlayback];
    }
    else {
        [EZOutput sharedOutput].outputDataSource = nil;
        [[EZOutput sharedOutput] stopPlayback];
    }

}

#pragma mark - Action Extensions

/*
 Give the visualization of the current buffer (this is almost exactly the openFrameworks audio input example)
 */
- (void)drawBufferPlot {
    // Change the plot type to the buffer plot
    self.audioPlot.plotType = EZPlotTypeBuffer;
    // Don't fill
    self.audioPlot.shouldFill = NO;
    // Don't mirror over the x-axis
    self.audioPlot.shouldMirror = NO;
}

/*
 Give the classic mirrored, rolling waveform look
 */
- (void)drawRollingPlot {
    // Change the plot type to the rolling plot
    self.audioPlot.plotType = EZPlotTypeRolling;
    // Fill the waveform
    self.audioPlot.shouldFill = YES;
    // Mirror over the x-axis
    self.audioPlot.shouldMirror = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
