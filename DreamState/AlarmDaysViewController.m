//
//  AlarmDaysViewController.m
//  DreamState
//
//  Created by Michal Thompson on 18/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AlarmDaysViewController.h"
#import "AlarmHelper.h"
#import "DayManager.h"
#import "Day.h"

NSString *const DSDaysCellIdentifier = @"DSDaysCellIdentifier";


@interface AlarmDaysViewController ()

@property(nonatomic) NSMutableArray *dayArray;
@property(weak, nonatomic) IBOutlet UITableView *dayTableView;

@end

@implementation AlarmDaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.dayArray = [[dateFormatter weekdaySymbols] mutableCopy];
}

#pragma mark table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dayArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = DSDaysCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = (self.dayArray)[(NSUInteger) indexPath.row];

    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont fontWithName:@"Solari" size:24]];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    NSString *dayAsString = thisCell.textLabel.text;

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *stringFromDay = [NSString stringWithFormat:@"%d", [[df weekdaySymbols] indexOfObject:dayAsString]];

    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;

        //[selectedDayArray addObject:thisCell.textLabel.text];
//        [selectedDayArray addObject:stringFromDay];

    } else {
        thisCell.accessoryType = UITableViewCellAccessoryNone;

        //[selectedDayArray removeObject:thisCell.textLabel.text];
//        [selectedDayArray removeObject:stringFromDay];
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
