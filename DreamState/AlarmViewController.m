//
//  AlarmViewController.m
//  DreamState
//
//  Created by Michal Thompson on 17/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AlarmViewController.h"
#import "AlarmDaysViewController.h"
#import "AlarmManager.h"

@interface AlarmViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;

@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (IBAction)saveAlarmButtonTouched:(id)sender {

    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.hour = [self.timePicker selectedRowInComponent:0];
    components.minute = [self.timePicker selectedRowInComponent:1];
    NSDate *pickerDate = [[NSCalendar currentCalendar] dateFromComponents:components];

    AlarmManager *alarmManager = [[AlarmManager alloc] init];
    [alarmManager saveAlarmWithDate:pickerDate];

//
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    transition.subtype = kCATransitionFromRight;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    [self.navigationController popViewControllerAnimated:NO];

}



-(void)storeAlarmInStore:(NSDate *)fireDate{

//    NSManagedObjectContext *context = [self managedObjectContext];
//
//    Alarm *alarm;
//
//    if (existingAlarm) {
//        alarm = existingAlarm;
//    }
//    else {
//        alarm = [NSEntityDescription
//                insertNewObjectForEntityForName:@"Alarm"
//                         inManagedObjectContext:context];
//
//    }
//
//    [alarm setValue:alarmName forKey:@"name"];
//    [alarm setValue:alarmSound forKey:@"sound"];
//    [alarm setValue:[NSNumber numberWithBool:YES] forKey:@"enabled"];
//
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
//    NSString *timeString = [outputFormatter stringFromDate:fireDate];
//
//    [alarm setValue:timeString forKey:@"time"];
//
//    for (NSManagedObject *aDay in alarm.day) {
//        [context deleteObject:aDay];
//    }
//    NSError *saveError = nil;
//    [context save:&saveError];
//
//    for (NSString *myArrayElement in alarmRepeatDays) {
//
//        Day *day = [NSEntityDescription
//                insertNewObjectForEntityForName:@"Day"
//                         inManagedObjectContext:context];
//
//        [day setValue:myArrayElement forKey:@"day"];
//
//        [day setValue:alarm forKey:@"alarm"];
//    }
//
//
//    NSError *error;
//    if (![context save:&error]) {
//        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue destinationViewController] isKindOfClass:[AlarmDaysViewController class]]){
//        ((AlarmDaysViewController *)[segue destinationViewController])

    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component)
    {
        case 0: return 24;
        case 1: return 60;
        default: return -1;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 50.0, 50.0)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Solari" size:30]];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    label.alpha = 1.0;
    if (row < 10) {
        [label setText:[NSString stringWithFormat:@"0%ld",(long)row]];
    }
    else {
        [label setText:[NSString stringWithFormat:@"%ld",(long)row]];
    }
    
    return label;
}

@end
