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

@implementation ArchiveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Solari" size:20.0]} forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDreamArray];
    [self.tableView reloadData];
}

- (void)loadDreamArray {
    DreamManager *manager = [[DreamManager alloc] init];
    self.dreamArray = [[manager getAllDreamsWithMostRecentFirst] mutableCopy];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showSelectedDreamView" sender:nil];
}

#pragma mark - Navigation

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

@end
