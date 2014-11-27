//
//  InformationTableViewController.m
//  DreamState
//
//  Created by Michal Thompson on 24/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "InformationTableViewController.h"

@implementation InformationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Solari" size:20.0]} forState:UIControlStateNormal];
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, tableView.bounds.size.width, 30)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.bounds.size.width - 10, 24)];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    [label setFont:[UIFont fontWithName:@"Solari" size:20]];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];

    return headerView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return @"";

    if (section == 0)
        return @"Record Settings";
    else
        return @"Other stuff";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"aboutSegue" sender:self];
        }
        if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"termsAndConditionsSegue" sender:self];
        }
//        else if (indexPath.row == 1) {
//            [self performSegueWithIdentifier:@"howToSegue" sender:self];
//        }
        else if (indexPath.row == 2) {
            [self performSegueWithIdentifier:@"acknowledgementsSegue" sender:self];
        }
    }
}

@end
