//
//  HomeViewController.m
//  DreamState
//
//  Created by Michal Thompson on 17/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "HomeViewController.h"
#import "NSDate+DateModifier.h"
#import "CSAnimationView.h"
#import "AlarmListTableViewController.h"

@interface HomeViewController ()
@property(weak, nonatomic) IBOutlet UILabel *nextAlarmLabel;
@property(weak, nonatomic) IBOutlet UILabel *nextAlarmTimeLabel;
@property(weak, nonatomic) IBOutlet CSAnimationView *animationView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setAlarmDetails];
    [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Solari" size:20.0]} forState:UIControlStateNormal];
}

- (void)setAlarmDetails {
    NSArray *notificationsArray = [[UIApplication sharedApplication] scheduledLocalNotifications];

    if (notificationsArray.count > 0) {
        UILocalNotification *firstNotification = notificationsArray[0];

        //Time
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        self.nextAlarmTimeLabel.text = [dateFormat stringFromDate:firstNotification.fireDate];

        //Day
        [dateFormat setDateFormat:@"EEEE"];
        NSString *dayText = [dateFormat stringFromDate:firstNotification.fireDate];

        NSDate *todayDate = [NSDate date];
        NSString *today = [dateFormat stringFromDate:todayDate];

        if ([today isEqualToString:dayText]) {
            dayText = @"Today";
        }

        NSString *tomorrow = [dateFormat stringFromDate:[todayDate addDays:1]];

        if ([tomorrow isEqualToString:dayText]) {
            dayText = @"Tomorrow";
        }

        self.nextAlarmLabel.text = dayText;
        [self.nextAlarmLabel layoutIfNeeded];
        [self.nextAlarmLabel updateConstraints];
    }
    else {
        self.nextAlarmLabel.text = @"Add alarm";
        self.nextAlarmTimeLabel.text = @"";
        self.animationView.delay = 0.5;
        self.animationView.duration = 0.5;
        self.animationView.type = CSAnimationTypeShake;
        [self.animationView startCanvasAnimation];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];

    if ([[segue destinationViewController] isKindOfClass:[AlarmListTableViewController class]]) {
        ((AlarmListTableViewController *) [segue destinationViewController]).shownFromHome = YES;
    }
}


@end
