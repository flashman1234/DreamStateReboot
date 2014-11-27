//
// Created by Michal Thompson on 24/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AboutViewController.h"


@interface AboutViewController ()
@property(weak, nonatomic) IBOutlet UIButton *emailButton;
@property(nonatomic, strong) MFMailComposeViewController *mc;
@property(weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *s = @"Half of our lives we spend in dream state, and its not necessarily the less interesting part.\n\n"
            "Most of us forget their dreams immediately after waking up, and most of us are too lazy to write or operate some recording-tool while still struggling to cope with their new waking state surroundings.\n\n"
            "Thats a pity, as many great inventions, narratives, songs, or just thoughts were born there but never made it cross the state-line.\n\n"
            "And thats why we created this App here.\n\n"
            "It's an alarm clock which can automatically start recording audio, allowing you to record and archive your dreams while they are still vivid.\n\n"
            "Dream State was created by Michal Thompson and Hannes Niepold\n\n"
            "Thanks to 8th Mode Music for supplying the 'A Mind of its Own', 'Blurred Atmospheres', 'Hard as Nails', and 'High Action' alarm sounds.";

    self.aboutLabel.text = s;
    [self.aboutLabel sizeToFit];
}

- (IBAction)emailButtonTouched:(id)sender {
    NSString *emailTitle = @"DreamState";
    NSString *messageBody = @"";
    NSArray *toRecipient = @[@"admin@dreamstate.squareknife.com"];

    self.mc = [[MFMailComposeViewController alloc] init];
    self.mc.mailComposeDelegate = self;
    [self.mc setSubject:emailTitle];
    [self.mc setMessageBody:messageBody isHTML:NO];
    [self.mc setToRecipients:toRecipient];

    [self presentViewController:self.mc animated:YES completion:NULL];
}

- (IBAction)websiteButtonTouched:(id)sender {
    NSString *mailString = [NSString stringWithFormat:@"http://dreamstate.squareknife.com"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end