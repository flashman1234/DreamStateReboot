//
//  AlarmSoundsViewController.m
//  DreamState
//
//  Created by Michal Thompson on 18/11/14.
//  Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import "AlarmSoundsViewController.h"
#import "SimpleAudioPlayer.h"

NSString *const DSSoundsCellIdentifier = @"DSSoundsCellIdentifier";


@interface AlarmSoundsViewController ()
@property(weak, nonatomic) IBOutlet UITableView *soundTableView;
@property(strong) NSArray *soundArray;

@end

@implementation AlarmSoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.soundArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarmSoundsArray"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.soundArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = DSSoundsCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = (self.soundArray)[(NSUInteger) indexPath.row];

    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont fontWithName:@"Solari" size:24]];

    cell.accessoryType = UITableViewCellAccessoryDetailButton;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self playSound:(self.soundArray)[(NSUInteger) indexPath.row]];

}

- (void)playSound:(NSString *)alarmSound {
    NSString *alarmSoundFile = [NSString stringWithFormat:@"%@.m4a", alarmSound];
    [SimpleAudioPlayer playFile:alarmSoundFile];
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
