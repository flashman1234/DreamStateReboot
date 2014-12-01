//
// Created by Michal Thompson on 24/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "NotificationManager.h"
#import "Alarm.h"
#import "AlarmManager.h"
#import "MuteChecker.h"


@implementation NotificationManager


- (void)loadNotifications {
    AlarmManager *manager = [[AlarmManager alloc] init];
    self.alarms = [manager getAllActiveAlarms];

    //delete any existing notifications for this alarm
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    self.numberOfAlarms = self.alarms.count;

    //now loop through Alarm, and set the notifications for each particular day.
    for (Alarm *alarm in self.alarms) {
        [self createNotificationForAlarm:alarm];
    }

    self.notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];

    self.muteChecker = [[MuteChecker alloc] initWithCompletionBlk:^(NSTimeInterval lapse, BOOL muted) {
        if (muted) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Device is muted!"
                                                         message:@"Alarms will only play a sound if the device is not muted."
                                                        delegate:self
                                               cancelButtonTitle:@"ok"
                                               otherButtonTitles:nil];
            [av show];
        }
    }];

    [self.muteChecker check];
}

- (void)setNotification:(NSDate *)finalAlarmDate alarm:(Alarm *)alarm {
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    notification.fireDate = finalAlarmDate;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];

    notification.alertBody = @"Would you like to record a dream?";
    NSDictionary *userInfoDict = @{@"AlarmName" : alarm.name, @"AlarmSound" : alarm.sound};
    notification.userInfo = userInfoDict;
    notification.soundName = [alarm.sound stringByAppendingString:@".m4a"];

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)createNotificationForAlarm:(Alarm *)alarm {
    int totalNumberOfNotifications = 100;
    int numberOfNotificationsPerAlarm = totalNumberOfNotifications / self.numberOfAlarms;

    //get date and convert to components
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate]; //

    //cut out hours and minutes from the alarm time
    NSInteger alarmHour = [[alarm.time substringToIndex:2] integerValue];
    NSInteger alarmMinutes = [[alarm.time substringFromIndex:3] integerValue];

    [components setHour:alarmHour];
    [components setMinute:alarmMinutes];

    //create alarm date
    NSDate *alarmDate = [[NSCalendar currentCalendar] dateFromComponents:components];

    //no days were set, so this alarm will run everyday
    if (alarm.day.count == 0 || alarm.day.count == 7) {

        for (int i = 0; i <= numberOfNotificationsPerAlarm; i++) {
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = i;

            NSDate *finalAlarmDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:alarmDate options:0];

            if ([finalAlarmDate compare:currentDate] == NSOrderedDescending) {
                [self setNotification:finalAlarmDate alarm:alarm];
            }
        }
    }
    else {
        int dayOffset = 0;
        int numberOfSetNotifications = 0;

        do {
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = dayOffset;

            NSDate *finalAlarmDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:alarmDate options:0];

            NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
            [weekday setDateFormat:@"EEEE"];

            NSString *possibleAlarmDay = [weekday stringFromDate:finalAlarmDate];
            NSString *stringFromDay = possibleAlarmDay;

            NSSet *days = [alarm.day valueForKey:@"day"];

            BOOL dayIsFound = [days containsObject:stringFromDay];

            if (dayIsFound) {
                if ([finalAlarmDate compare:currentDate] == NSOrderedDescending) {
                    [self setNotification:finalAlarmDate alarm:alarm];
                    numberOfSetNotifications = numberOfSetNotifications + 1;
                }
            }

            dayOffset = dayOffset + 1;

        } while (numberOfSetNotifications < numberOfNotificationsPerAlarm);
    }
}

@end