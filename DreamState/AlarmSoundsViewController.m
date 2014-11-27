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
@property(nonatomic) NSInteger indexOfSoundPlaying;

@end

@implementation AlarmSoundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.soundArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarmSoundsArray"];
    self.indexOfSoundPlaying = -1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SimpleAudioPlayer stopAllPlayers];
}

#pragma mark - Table view data source

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

    UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [accessoryButton setBackgroundImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
    CGRect frame = CGRectMake(0.0, 0.0, 28, 28);
    accessoryButton.frame = frame;
    [accessoryButton addTarget:self action:@selector(playButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];

    cell.accessoryView = accessoryButton;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *sound = thisCell.textLabel.text;
    if ([self.delegate respondsToSelector:@selector(setAlarmSoundWithSoundName:)]) {
        [self.delegate setAlarmSoundWithSoundName:sound];
    }

    [self.navigationController popViewControllerAnimated:NO];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *) cell.accessoryView;


    if (indexPath.row == self.indexOfSoundPlaying) {
        [button setBackgroundImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];
        [SimpleAudioPlayer stopAllPlayers];
        self.indexOfSoundPlaying = -1;
    }
    else {
        [SimpleAudioPlayer stopAllPlayers];
        [self playSound:(self.soundArray)[(NSUInteger) indexPath.row] withAceesoryButton:button];
        self.indexOfSoundPlaying = indexPath.row;
        [button setBackgroundImage:[UIImage imageNamed:@"pauseIcon"] forState:UIControlStateNormal];

    }
}

#pragma mark actions

- (void)playButtonTapped:(id)playButtonTapped event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.soundTableView];
    NSIndexPath *indexPath = [self.soundTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        [self tableView:self.soundTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

- (void)playSound:(NSString *)alarmSound withAceesoryButton:(UIButton *)accessoryButton {
    NSString *alarmSoundFile = [NSString stringWithFormat:@"%@.m4a", alarmSound];
    [SimpleAudioPlayer playFile:alarmSoundFile withCompletionBlock:^(BOOL b) {
        [accessoryButton setBackgroundImage:[UIImage imageNamed:@"playIcon"] forState:UIControlStateNormal];

    }];
}

@end
