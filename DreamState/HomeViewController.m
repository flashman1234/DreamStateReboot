//
//  HomeViewController.m
//  DreamState
//
//  Created by Michal Thompson on 17/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "HomeViewController.h"
#import "DSCoreDataContextProvider.h"
#import "Day.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nextAlarmLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setAlarmDetails];
}


-(void)setAlarmDetails{
    NSArray *notificationsArray = [[UIApplication sharedApplication] scheduledLocalNotifications];

    if (notificationsArray.count > 0) {
        UILocalNotification *firstNotification = notificationsArray[0];

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: @"HH:mm"];
        self.nextAlarmLabel.text = [dateFormat  stringFromDate:firstNotification.fireDate];

        [dateFormat setDateFormat: @"EEEE"];
        NSString *dayText = [dateFormat  stringFromDate:firstNotification.fireDate];

        NSDate *todayDate = [NSDate date];
        NSString *today = [dateFormat  stringFromDate:todayDate];




        if ([today isEqualToString:dayText]) {
            dayText = @"Today";
            //dayText = [@"Today-" stringByAppendingString:today];
        }

        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:todayDate];
        NSInteger theDay = [todayComponents day];
        NSInteger theMonth = [todayComponents month];
        NSInteger theYear = [todayComponents year];

        // now build a NSDate object for yourDate using these components
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:theDay];
        [components setMonth:theMonth];
        [components setYear:theYear];
        NSDate *thisDate = [gregorian dateFromComponents:components];

        // now build a NSDate object for the next day
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:1];
        NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];

        NSString *tomorrow = [dateFormat  stringFromDate:nextDate];

        if ([tomorrow isEqualToString:dayText]) {
            dayText = @"Tomorrow";
            //dayText = [@"Tomorrow-" stringByAppendingString:tomorrow];
        }

//
//
//
//
        self.nextAlarmLabel.text = dayText;
        [self.nextAlarmLabel layoutIfNeeded];
        [self.nextAlarmLabel updateConstraints];
//        [nextAlarmTimeLabel setFont:[UIFont fontWithName:@"Solari" size:60]];
//
//        UIImageView *bellViewTemp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blackalarmbell.png"]];
//        bellView = bellViewTemp;
//        bellView.tag = 99;
//        [bellView setFrame:CGRectMake(200, 25, 50, 50)];
//        [nextAlarmView addSubview:bellView];

    }
    else {
//        [nextAlarmTimeLabel setFont:[UIFont fontWithName:@"Solari" size:40]];
        self.nextAlarmLabel.text = @"Add alarm";
//        nextAlarmDayLabel.text = @"";
//
//
//        for (UIView *v in nextAlarmView.subviews) {
//            if ([v isKindOfClass:[UIImageView class]]) {
//                [v removeFromSuperview];
//            }
//        }

//        UIImageView *theBellView = (UIImageView *)[self.view viewWithTag:99];
//
//        [theBellView removeFromSuperview];
//        theBellView = nil;

    }
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
