//
// Created by Michal Thompson on 24/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AboutViewController.h"


@interface AboutViewController ()
@property(weak, nonatomic) IBOutlet UIButton *emailButton;
@property(nonatomic, strong) MFMailComposeViewController *mc;

@end

@implementation AboutViewController

- (IBAction)emailButtonTouched:(id)sender {
    NSString *emailTitle = @"DreamState";
    NSString *messageBody = @"";
    NSArray *toRecipents = @[@"admin@dreamstate.squareknife.com"];

    self.mc = [[MFMailComposeViewController alloc] init];
    self.mc.mailComposeDelegate = self;
    [self.mc setSubject:emailTitle];
    [self.mc setMessageBody:messageBody isHTML:NO];
    [self.mc setToRecipients:toRecipents];

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

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end