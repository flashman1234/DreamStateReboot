//
// Created by Michal Thompson on 18/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AppDelegate.h"
#import "AlarmHelper.h"

@implementation AlarmHelper

+ (void)searchForAlarmSounds {
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:bundleRoot];

    NSMutableArray *alarmSoundsArray = [[NSMutableArray alloc] init];

    NSString *filename;

    while ((filename = [direnum nextObject])) {
        if ([filename hasSuffix:@".m4a"]) {
            [alarmSoundsArray addObject:[filename stringByDeletingPathExtension]];
        }
    }

    [[NSUserDefaults standardUserDefaults] setObject:alarmSoundsArray forKey:@"alarmSoundsArray"];
}
@end