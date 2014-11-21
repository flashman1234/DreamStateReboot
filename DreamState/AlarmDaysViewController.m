//
//  AlarmDaysViewController.m
//  DreamState
//
//  Created by Michal Thompson on 18/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AlarmDaysViewController.h"
#import "AlarmDelegate.h"

NSString *const DSDaysCellIdentifier = @"DSDaysCellIdentifier";

@interface AlarmDaysViewController ()

@property(nonatomic) NSMutableArray *weekDayArray;
@property(weak, nonatomic) IBOutlet UITableView *dayTableView;

@end

@implementation AlarmDaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.selectedDayArray) {
        self.selectedDayArray = [[NSMutableArray alloc] init];
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.weekDayArray = [[dateFormatter weekdaySymbols] mutableCopy];
}

- (IBAction)addDaysButtonTouched:(id)sender {

    if ([self.delegate respondsToSelector:@selector(setAlarmDaysWithDayNameArray:)]) {
        [self.delegate setAlarmDaysWithDayNameArray:self.selectedDayArray];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
