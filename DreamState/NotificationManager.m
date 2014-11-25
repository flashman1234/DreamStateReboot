//
// Created by Michal Thompson on 24/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "NotificationManager.h"
#import "Alarm.h"
#import "AlarmManager.h"


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

}

- (void)setNotification:(NSDate *)finalAlarmDate alarm:(Alarm *)alarm {
    //create notification
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    notification.fireDate = finalAlarmDate;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];

    //NSString *stringFromDate = [dateFormat stringFromDate:notification.fireDate];

    notification.alertBody = @"Would you like to record a dream?";

    NSDictionary *userInfoDict = @{@"AlarmName" : alarm.name, @"AlarmSound" : alarm.sound};

    notification.userInfo = userInfoDict;

    notification.soundName = [alarm.sound stringByAppendingString:@".m4a"];
//    notification.soundName = UILocalNotificationDefaultSoundName;

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)createNotificationForAlarm:(Alarm *)alarm {

    int totalNumberOfNotifications = 5;
    int numberOfNotificationsPerAlarm = totalNumberOfNotifications / self.numberOfAlarms;

    //get date and convert to components
    NSDate *curentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *compoNents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:curentDate]; //

    //cut out hours and minutes from the alarm time
    NSInteger alarmHour = [[alarm.time substringToIndex:2] integerValue];
    NSInteger alarmMinutes = [[alarm.time substringFromIndex:3] integerValue];

    [compoNents setHour:alarmHour];
    [compoNents setMinute:alarmMinutes];

    //create alarm date
    NSDate *alarmDate = [[NSCalendar currentCalendar] dateFromComponents:compoNents];

    //no days were set, so this alarm will run everyday
    if (alarm.day.count == 0) {

        for (int i = 0; i <= numberOfNotificationsPerAlarm; i++) {

            //increase day by increment
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = i;

            NSDate *finalAlarmDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:alarmDate options:0];

            //if (finalAlarmDate > curentDate) {
            if ([finalAlarmDate compare:curentDate] == NSOrderedDescending) {
                [self setNotification:finalAlarmDate alarm:alarm];
            }
        }
    }
    else {

        int dayOffest = 0;
        int numberOfSetNotifications = 0;

        do {

            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = dayOffest;

            NSDate *finalAlarmDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:alarmDate options:0];

            NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
            [weekday setDateFormat:@"EEEE"];

            NSString *possibleAlarmDay = [weekday stringFromDate:finalAlarmDate];

            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            NSString *stringFromDay = possibleAlarmDay;

            NSSet *days = [alarm.day valueForKey:@"day"];

            BOOL dayIsFound = [days containsObject:stringFromDay];

            if (dayIsFound) {
                if ([finalAlarmDate compare:curentDate] == NSOrderedDescending) {
                    [self setNotification:finalAlarmDate alarm:alarm];
                    numberOfSetNotifications = numberOfSetNotifications + 1;
                }
            }

            dayOffest = dayOffest + 1;

        } while (numberOfSetNotifications < numberOfNotificationsPerAlarm);

    }

}

@end