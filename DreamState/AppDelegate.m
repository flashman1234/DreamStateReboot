//
//  AppDelegate.m
//  DreamState
//
//  Created by Michal Thompson on 17/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <SimpleAudioPlayer/SimpleAudioPlayer.h>
#import "AppDelegate.h"
#import "AlarmHelper.h"
#import "NotificationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AlarmHelper searchForAlarmSounds];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self performSelectorInBackground:@selector(updateNotifications) withObject:nil];

// move this to separate file.
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = NULL;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    if( err ){
        NSLog(@"There was an error creating the audio session");
    }
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:NULL];
    if( err ){
        NSLog(@"There was an error sending the audio to the speakers");
    }

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }

    UITabBarController *_tabBarController = (UITabBarController *)_window.rootViewController;
    _tabBarController.delegate = self;

    return YES;
}



- (void)updateNotifications {
    NotificationManager *notificationLoader = [[NotificationManager alloc] init];
    [notificationLoader loadNotifications];
}

#pragma mark tab bar delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    if ([tabBarController.viewControllers[tabBarController.selectedIndex] isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *x = tabBarController.viewControllers[tabBarController.selectedIndex];

        [x popToRootViewControllerAnimated:NO];
    }

    return YES;
}



-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

//    appOpensFromAlarm = YES;
    NSDictionary *notDict = notification.userInfo;
    NSString *alarmSoundName = [notDict valueForKey:@"AlarmSound"];

    NSString *alarmName = [notification.userInfo valueForKey:@"AlarmName"];

    if (application.applicationState == UIApplicationStateInactive ) {

//        [[NSNotificationCenter defaultCenter] postNotificationName:localReceived object:self];
    }

    if(application.applicationState == UIApplicationStateActive ) {

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];

        //NSString *stringFromDate = [dateFormat stringFromDate:notification.fireDate];

        [self playAlarmSound:alarmSoundName];
        UIAlertView *alert = [[UIAlertView alloc]
                initWithTitle: NSLocalizedString(alarmName, nil)
                      message: NSLocalizedString(@"Would you like to record a dream?",nil)
                     delegate: self
            cancelButtonTitle: NSLocalizedString(@"No",nil)
            otherButtonTitles: NSLocalizedString(@"Yes",nil), nil];
        [alert show];
    }
}

- (void)playAlarmSound:(NSString *)alarmSound {
    NSString *alarmSoundFile = [NSString stringWithFormat:@"%@.m4a", alarmSound];
    [SimpleAudioPlayer playFile:alarmSoundFile withCompletionBlock:^(BOOL b) {

    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
