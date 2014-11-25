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
#import "AlarmSoundsViewController.h"
#import "Alarm.h"
#import "AlarmHelper.h"

#define kRowsInPicker 100


@interface AlarmViewController ()
@property(weak, nonatomic) IBOutlet UIButton *alarmDaysButton;
@property(weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property(weak, nonatomic) IBOutlet UIButton *alarmSoundButton;
@property(weak, nonatomic) IBOutlet UITextField *alarmNameTextField;

@property(nonatomic) NSMutableArray *alarmDaysNamesArray;
@property(nonatomic) NSString *alarmSound;
@property(nonatomic) NSString *alarmName;

@end

@implementation AlarmViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.existingAlarm) {
        [self loadExistingAlarm];
    }
    else {
        [self loadInitialAlarm];
    }
}

- (void)loadInitialAlarm {
    self.alarmName = @"Alarm name";
    self.alarmNameTextField.text = self.alarmName;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.alarmDaysNamesArray = [[dateFormatter weekdaySymbols] mutableCopy];
    [self.alarmDaysButton setTitle:@"Everyday" forState:UIControlStateNormal];

    [self setAlarmTime:[NSDate date]];

    self.alarmSound = @"Alarm bell 1";
    [self.alarmSoundButton setTitle:@"Alarm bell 1" forState:UIControlStateNormal];
}

- (void)loadExistingAlarm {
    self.alarmName = self.existingAlarm.name;
    self.alarmSound = self.existingAlarm.sound;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSDate *alarmTime = [dateFormat dateFromString:self.existingAlarm.time];

    self.alarmDaysNamesArray = [[AlarmHelper dayNameArrayFromDayArray:[self.existingAlarm.day allObjects]] mutableCopy];

    //ui
    self.alarmNameTextField.text = self.alarmName;

    [self.alarmSoundButton setTitle:self.existingAlarm.sound forState:UIControlStateNormal];

    [self setAlarmTime:alarmTime];




    [self.alarmDaysButton setTitle:[AlarmHelper orderedShortDayNamesFromDayArray:[self.existingAlarm.day allObjects]] forState:UIControlStateNormal];
}

- (void)setAlarmTime:(NSDate *)alarmTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:alarmTime];
    NSInteger currentHour = components.hour;
    NSInteger currentMinutes = components.minute;
    [self.timePicker selectRow:currentHour inComponent:0 animated:YES];
    [self.timePicker selectRow:currentMinutes inComponent:1 animated:YES];
}

- (IBAction)saveAlarmButtonTouched:(id)sender {

    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = [self.timePicker selectedRowInComponent:0];
    components.minute = [self.timePicker selectedRowInComponent:1];
    NSDate *pickerDate = [[NSCalendar currentCalendar] dateFromComponents:components];

    AlarmManager *alarmManager = [[AlarmManager alloc] init];

    if (self.existingAlarm)
    {
        [alarmManager updateAlarm:self.existingAlarm
                             name:self.alarmNameTextField.text
                             date:pickerDate
                 fullNameDayArray:self.alarmDaysNamesArray
                            sound:self.alarmSound];
    }
    else
    {
        [alarmManager saveAlarmWithName:self.alarmNameTextField.text
                                   date:pickerDate
                       fullNameDayArray:self.alarmDaysNamesArray
                                  sound:self.alarmSound];
    }

    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[AlarmDaysViewController class]]) {
        ((AlarmDaysViewController *) [segue destinationViewController]).delegate = self;
        ((AlarmDaysViewController *) [segue destinationViewController]).selectedDayArray = self.alarmDaysNamesArray;
    }
    else if ([[segue destinationViewController] isKindOfClass:[AlarmSoundsViewController class]]) {
        ((AlarmSoundsViewController *) [segue destinationViewController]).delegate = self;
    }
}

- (void)setAlarmDaysWithDayNameArray:(NSArray *)dayNameArray {
    self.alarmDaysNamesArray = [dayNameArray mutableCopy];

    NSString *string = [AlarmHelper orderedShortDayNamesFromArrayOfDayNames:dayNameArray];
    [self.alarmDaysButton setTitle:string forState:UIControlStateNormal];
    [self.alarmDaysButton.titleLabel layoutIfNeeded];
}

- (void)setAlarmSoundWithSoundName:(NSString *)soundName {
    self.alarmSound = soundName;
    self.alarmSoundButton.titleLabel.text = soundName;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 75;
}

#pragma mark - picker view

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return kRowsInPicker;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return 24;
        case 1:
            return 60;
        default:
            return -1;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    UILabel *tView = (UILabel *) view;
    if (!tView) {
        tView = [[UILabel alloc] init];

        [tView setTextAlignment:NSTextAlignmentCenter];
        [tView setFont:[UIFont fontWithName:@"Solari" size:50]];
        tView.textColor = [UIColor whiteColor];
        tView.backgroundColor = [UIColor blackColor];
    }

    if (row < 10) {
        [tView setText:[NSString stringWithFormat:@"0%ld", (long) row]];
    }
    else {
        [tView setText:[NSString stringWithFormat:@"%ld", (long) row]];
    }
    return tView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.timePicker.frame.size.width / 2;
}

@end
