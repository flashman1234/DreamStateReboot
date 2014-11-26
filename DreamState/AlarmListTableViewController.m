//
//  AlarmListTableViewController.m
//  DreamState
//
//  Created by Michal Thompson on 19/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AlarmListTableViewController.h"
#import "AlarmManager.h"
#import "Alarm.h"
#import "AlarmViewController.h"
#import "DSCoreDataContextProvider.h"
#import "AlarmHelper.h"
#import "NotificationManager.h"

@interface AlarmListTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property(nonatomic) NSArray *alarmArray;
@end

@implementation AlarmListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Solari" size:20.0]} forState:UIControlStateNormal];
    [self.addButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Solari" size:20.0]} forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadAlarmArray];
    [self.tableView reloadData];
}

- (void)loadAlarmArray {
    AlarmManager *manager = [[AlarmManager alloc] init];
    self.alarmArray = [manager getAllAlarms];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.alarmArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmDetailsCell"];
    Alarm *alarm = (self.alarmArray)[(NSUInteger) indexPath.row];

    UILabel *timeLabel = (UILabel *) [cell viewWithTag:1];
    timeLabel.text = alarm.time;
    [timeLabel sizeToFit];
    [timeLabel layoutIfNeeded];

    UILabel *nameLabel = (UILabel *) [cell viewWithTag:2];
    nameLabel.text = alarm.name;

    UILabel *daysLabel = (UILabel *) [cell viewWithTag:3];
    daysLabel.text = [AlarmHelper orderedShortDayNamesFromDayArray:[alarm.day allObjects]];

    UISwitch *enabledSwitch = (UISwitch *) [cell viewWithTag:4];
    enabledSwitch.on = [alarm.enabled boolValue];
    [enabledSwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showAlarmView" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)updateSwitchAtIndexPath:(id)sender {
    UISwitch *switchControl = sender;
    UITableViewCell *clickedCell = (UITableViewCell *) [[sender superview] superview];
    NSIndexPath *clickedButtonPath = [self.tableView indexPathForCell:clickedCell];

    Alarm *alarm = (self.alarmArray)[(NSUInteger) (clickedButtonPath.row)];
    [alarm setValue:@(switchControl.on) forKey:@"enabled"];
    [[DSCoreDataContextProvider sharedInstance] saveContext];

    [self updateNotifications];
}

- (void)updateNotifications {
    NotificationManager *notificationLoader = [[NotificationManager alloc] init];
    [notificationLoader loadNotifications];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.length > 0) {
        if ([[segue destinationViewController] isKindOfClass:[AlarmViewController class]]) {
            Alarm *existingAlarm = (self.alarmArray)[(NSUInteger) indexPath.row];
            ((AlarmViewController *) [segue destinationViewController]).existingAlarm = existingAlarm;
        }
    }
}


@end
