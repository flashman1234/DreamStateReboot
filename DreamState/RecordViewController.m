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
//#import "AVFoundation"
#import "UITextFieldNoMenu.h"
#import "RecordingImageView.h"
#import "DreamManager.h"

@interface RecordViewController ()
@property(weak, nonatomic) IBOutlet UIButton *recordButton;
@property(nonatomic) BOOL autoRecord;
@property(nonatomic) BOOL showVideoPreview;
@property(nonatomic) BOOL isRecording;
@property(nonatomic) BOOL loadedFromAlarm;
@end

@implementation RecordViewController

- (IBAction)recordButtonTouched:(id)sender {
    NSLog(@"record button touched");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSTimer *levelTimerTemp = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];

    self.levelTimer = levelTimerTemp;
    [self addSegmentControl];

    [self addNoMenuTextField];

    CGFloat myWidth = 26.0f;
    CGFloat myHeight = 30.0f;
    UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myWidth, myHeight)];
    [myButton setImage:[UIImage imageNamed:@"whitex.png"] forState:UIControlStateNormal];
    [myButton setImage:[UIImage imageNamed:@"whitex.png"] forState:UIControlStateHighlighted];

    [myButton addTarget:self action:@selector(doClear:) forControlEvents:UIControlEventTouchUpInside];

    self.dreamNameTextField.rightView = myButton;
    self.dreamNameTextField.rightViewMode = UITextFieldViewModeAlways;

    self.dreamNameTextField.text = self.dream.name;
    self.dreamNameTextField.delegate = self;

}

- (void)addNoMenuTextField {
    UITextFieldNoMenu *textField = [[UITextFieldNoMenu alloc] initWithFrame:CGRectMake(10, 170, 300, 30)];
    self.dreamNameTextField = textField;

    self.dreamNameTextField.backgroundColor = [UIColor blackColor];
    [self.dreamNameTextField setFont:[UIFont fontWithName:@"Solari" size:20]];
    self.dreamNameTextField.textColor = [UIColor whiteColor];
    self.dreamNameTextField.borderStyle = UITextBorderStyleBezel;
    self.dreamNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.dreamNameTextField.returnKeyType = UIReturnKeyDone;
}

- (void)addSegmentControl {
    NSArray *itemArray = @[@"Record", @"Stop"];
    UISegmentedControl *segmentedControlTemp = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.segmentedControl = segmentedControlTemp;
    self.segmentedControl.frame = CGRectMake(35, 330, 250, 50);
//    self.segmentedControl. = UISegmentedControlStyleBar;
//    UIFont *font = [UIFont fontWithName:@"Solari" size:20];
//    NSDictionary *attributes = @{UITextAttributeFont : font};
//    [self.segmentedControl setTitleTextAttributes:attributes
//                                         forState:UIControlStateNormal];
//
//
//    NSDictionary *selectedAttributes = @{UITextAttributeFont : [UIFont fontWithName:@"Solari" size:20],
//            UITextAttributeTextColor : [UIColor redColor]};
//    [self.segmentedControl setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];


    self.segmentedControl.tintColor = [UIColor darkGrayColor];

    [self.segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getUserDefaults];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.segmentedControl.selectedSegmentIndex = -1;
    [super viewWillAppear:animated];
}

//- (void)addTextField {
//
//    self.dreamNameTextField.text = self.dream.name;
//    self.dreamNameTextField.delegate = self;
//
//
//    [self.view addSubview:self.dreamNameTextField];
//    [self.dreamNameTextField becomeFirstResponder];
//
//}

- (void)textFieldDidBeginEditing:(UITextField *)iTextField {
    [iTextField selectAll:self];
}

- (void)doClear:(id)sender {
    self.dreamNameTextField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
//    NSManagedObjectContext *context = [self managedObjectContext];

    self.dream.name = self.dreamNameTextField.text;

//    NSError *error;
//    if (![context save:&error]) {
//        NSLog(@"Couldn't save audio dream: %@", [error localizedDescription]);
//    }

    [theTextField resignFirstResponder];

    [self.tabBarController setSelectedIndex:2];

    return YES;
}


#pragma mark - Record and play video

- (void)playDream {
//
//    self.mediaPlayer = [[MPMoviePlayerController alloc] initWithContentURL: fileURL];
//    mediaPlayer.view.tag = 100;
////
////    NSString *fileType = [[fileURL absoluteString] substringFromIndex:[[fileURL absoluteString] length] - 3];
////    if ([fileType isEqualToString:@"mov"]) {
////        [mediaPlayer.view setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
////    }
//
//    self.mediaPlayer.controlStyle = MPMovieControlStyleEmbedded;
//    [mediaPlayer.view setFrame: CGRectMake(0, 30, self.view.bounds.size.width, 50)];
//
//    [self.view addSubview:mediaPlayer.view];
//    mediaPlayer.shouldAutoplay = NO;
//    [mediaPlayer prepareToPlay];
//    [self addTextField];

}

- (void)levelTimerCallback:(NSTimer *)timer {
    if (self.isRecording) {
        [self.aVAudioRecorder updateMeters];

        const double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (0.05 * [self.aVAudioRecorder peakPowerForChannel:0]));
        self.lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * self.lowPassResults;
        self.sineWaveView.passedInValue = (CGFloat) self.lowPassResults;
        [self.sineWaveView setNeedsDisplay];
    }
}

- (void)startRecordingAudio {
    if (self.mediaPlayer) {
        [self.mediaPlayer stop];
        [self.mediaPlayer.view removeFromSuperview];
    }
    if (self.dreamNameTextField) {
        [self.dreamNameTextField removeFromSuperview];
    }

    self.isRecording = YES;

    self.fileURL = [NSURL fileURLWithPath:[self createFileName:@"caf"]];

    self.recordSettings=[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                                                [NSNumber numberWithInt:16000.0],AVSampleRateKey,
                                                                [NSNumber numberWithInt: 1],AVNumberOfChannelsKey,
                                                                [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                                                [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                                                [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                    nil];
    NSError *error = nil;

    AVAudioRecorder *aVAudioRecorderTemp = [[AVAudioRecorder alloc]
            initWithURL:self.fileURL
               settings:self.recordSettings
                  error:&error];
    if (error){
        NSLog(@"[AVAudioRecorder alloc] error: %@", [error localizedDescription]);
    }
    else {
        self.aVAudioRecorder = aVAudioRecorderTemp;
        self.aVAudioRecorder.meteringEnabled = YES;


        [self.aVAudioRecorder prepareToRecord];
        [self.aVAudioRecorder record];

//        NSManagedObjectContext *context = [self managedObjectContext];

        DreamManager *manager = [[DreamManager alloc] init];

        self.dream = [manager createNewDream];

        NSDateFormatter *dreamDateFormatter = [[NSDateFormatter alloc] init];
        [dreamDateFormatter setDateFormat: @"dd MMM yyyy"];

        NSString *dreamDateAsString = [dreamDateFormatter stringFromDate:[NSDate date]];

        NSDateFormatter *dreamTimeFormatter = [[NSDateFormatter alloc] init];
        [dreamTimeFormatter setDateFormat: @"HH:mm"];

        NSString *dreamTimeAsString = [dreamTimeFormatter stringFromDate:[NSDate date]];

        self.dream.name = [dreamDateAsString stringByAppendingString:@""];
        self.dream.fileUrl = [self.fileURL path];
        self.dream.date = dreamDateAsString;
        self.dream.mediaType = @"Audio";
        self.dream.dateCreated = [NSDate date];
        self.dream.time = dreamTimeAsString;
        [manager saveDream:self.dream];
    }

    RecordingImageView *swView2 = [[RecordingImageView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 140)];

    self.sineWaveView = swView2;
    self.sineWaveView.backgroundColor = [UIColor blackColor];
    self.sineWaveView.passedInValue = 0.0f;
    [self.view insertSubview:self.sineWaveView atIndex:self.view.subviews.count - 1];
}

- (void)stopRecordingAudio {
    if (self.sineWaveView) {
        [self.sineWaveView removeFromSuperview];
    }
    self.isRecording = NO;
    [self.aVAudioRecorder stop];
    [self playDream];
}


#pragma mark - view methods

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc {

    if (self = [super init]) {
        self.managedObjectContext = moc;

        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Record"];
        UIImage *i = [UIImage imageNamed:@"record.png"];
        [tbi setImage:i];
    }

    return self;
}


- (void)segmentValueChanged:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0)
        [self startRecordingAudio];

    else if (segment.selectedSegmentIndex == 1) {
        if (self.isRecording) {
            [self stopRecordingAudio];
        }
        else {
            segment.selectedSegmentIndex = -1;
        }
    }

}

- (void)viewDidAppear:(BOOL)animated {
    //if (!loadedFromAlarm) {
    if (self.autoRecord) {
        self.segmentedControl.selectedSegmentIndex = 0;
        [self startRecordingAudio];
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

    if (self.dreamNameTextField) {
        [self.dreamNameTextField removeFromSuperview];
    }

    UIView *b = (UIView *) [self.view viewWithTag:100];
    [b removeFromSuperview];
    b = nil;

    self.isRecording = NO;
}






//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
//}

- (void)getUserDefaults {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.autoRecord = [self.userDefaults boolForKey:@"AutoRecord"];


//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription
//            entityForName:@"Settings" inManagedObjectContext:managedObjectContext];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//
//
//    NSArray *settings = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
//
//    Settings *set = [settings objectAtIndex:0];
//
//    autoRecord = set.autoRecord.boolValue;



}

- (void)doHighlight:(UIButton *)b {

    [b setHighlighted:self.isRecording];
}


#pragma mark - file handlers

- (NSString *)createFileName:(NSString *)fileType {
    NSArray *documentDirectoryPaths;
    NSString *documentDirectory;

    documentDirectoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDirectory = documentDirectoryPaths[0];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *theFileName = [NSString stringWithFormat:@"%@.%@", [formatter stringFromDate:[NSDate date]], fileType];
    NSString *fullFilePath = [documentDirectory stringByAppendingPathComponent:theFileName];
    // fileURLAsString = fullFilePath;
    return fullFilePath;
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
