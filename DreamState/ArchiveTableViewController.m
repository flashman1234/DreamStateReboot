//
//  ArchiveTableViewController.m
//  DreamState
//
//  Created by Michal Thompson on 17/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "ArchiveTableViewController.h"
#import "DreamManager.h"
#import "Dream.h"
#import "SelectedDreamViewController.h"

@interface ArchiveTableViewController ()

@end

@implementation ArchiveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Solari" size:20.0]} forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDreamArray];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dreamArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArchiveCell"];
    Dream *dream = (self.dreamArray)[(NSUInteger) indexPath.row];

    UILabel *nameLabel = (UILabel *) [cell viewWithTag:1];
    nameLabel.text = dream.name;

    UILabel *timeLabel = (UILabel *) [cell viewWithTag:2];
    timeLabel.text = dream.time;
    [timeLabel sizeToFit];
    [timeLabel layoutIfNeeded];

    return cell;
}

- (void)loadDreamArray {
    DreamManager *manager = [[DreamManager alloc] init];

    self.dreamArray = [[manager getAllDreams] mutableCopy];
}


#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showSelectedDreamView" sender:nil];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.length > 0) {
        if ([[segue destinationViewController] isKindOfClass:[SelectedDreamViewController class]]) {
            Dream *selectedDream = (self.dreamArray)[(NSUInteger) indexPath.row];
            ((SelectedDreamViewController *) [segue destinationViewController]).selectedDream = selectedDream;

            self.navigationController.navigationBar.backItem.title = @"something";
        }
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
