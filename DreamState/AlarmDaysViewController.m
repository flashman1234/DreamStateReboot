//
//  AlarmDaysViewController.m
//  DreamState
//
//  Created by Michal Thompson on 18/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AlarmDaysViewController.h"
#import "AlarmDelegate.h"
#import "DayHelper.h"

NSString *const DSDaysCellIdentifier = @"DSDaysCellIdentifier";

@interface AlarmDaysViewController ()

@property(nonatomic) NSMutableArray *weekDayArray;
@property(weak, nonatomic) IBOutlet UITableView *dayTableView;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *okButton;

@end

@implementation AlarmDaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.selectedDayArray) {
        self.selectedDayArray = [[NSMutableArray alloc] init];
    }

    [self.okButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Solari" size:20.0]} forState:UIControlStateNormal];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.weekDayArray = [[dateFormatter weekdaySymbols] mutableCopy];
}

- (IBAction)addDaysButtonTouched:(id)sender {

    NSArray *sortedDayArray = [DayHelper reorderSelectedDaysArray:self.selectedDayArray];

    if ([self.delegate respondsToSelector:@selector(setAlarmDaysWithDayNameArray:)]) {
        [self.delegate setAlarmDaysWithDayNameArray:sortedDayArray];
    }

    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.weekDayArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = DSDaysCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = (self.weekDayArray)[(NSUInteger) indexPath.row];

    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont fontWithName:@"Solari" size:24]];

    for (NSString *selectedDay in self.selectedDayArray) {
        if ([selectedDay isEqualToString:(self.weekDayArray)[(NSUInteger) indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *dayAsString = thisCell.textLabel.text;

    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedDayArray addObject:dayAsString];
    } else {
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedDayArray removeObject:dayAsString];
    }
}

@end
