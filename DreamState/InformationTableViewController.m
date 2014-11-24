//
//  InformationTableViewController.m
//  DreamState
//
//  Created by Michal Thompson on 24/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "InformationTableViewController.h"

@interface InformationTableViewController ()

@end

@implementation InformationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }

    return 3;
}

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

    if (section == 0)
        return @"Record Settings";
    else
        return @"Other stuff";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"aboutSegue" sender:self];
        }
        else if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"termsAndConditionsSegue" sender:self];
        }
        else if (indexPath.row == 2) {
            [self performSegueWithIdentifier:@"howToSegue" sender:self];
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
