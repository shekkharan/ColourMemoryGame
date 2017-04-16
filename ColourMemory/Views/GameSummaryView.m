//
//  GameSummaryView.m
//  ColourMemory
//
//  Created by Shekhar on 11/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "GameSummaryView.h"
#import "Game.h"
#import "GameSummaryTableViewCell.h"

@implementation GameSummaryView

+ (GameSummaryView *)gameSummaryViewWithFrame:(CGRect)frame andGame:(Game *)game
{
  GameSummaryView *gameSummaryView = [[[NSBundle mainBundle] loadNibNamed:@"GameSummaryView" owner:self options:nil] objectAtIndex:0];
  gameSummaryView.frame = frame;
  gameSummaryView.game = game;
  [gameSummaryView setup];
  return gameSummaryView;
}

- (void)setup
{
  
  self.totalPointsLabel.text = [NSString stringWithFormat:@"YOU'VE SCORED %ld POINTS",(long)self.game.totalScore];
}

- (void)showSummary
{
  if (self.gameSummaryTableView) {
    [self.gameSummaryTableView setDelegate:self];
    [self.gameSummaryTableView setDataSource:self];
    [self.gameSummaryTableView beginUpdates];
    NSMutableArray * cardIndexPaths = [NSMutableArray array];
    for (int i = 0 ; i < self.game.rounds.count; i ++) {
      [cardIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.gameSummaryTableView insertRowsAtIndexPaths:cardIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.gameSummaryTableView endUpdates];
  }
}

- (void)dealloc
{
  self.gameSummaryTableView.delegate = nil;
  self.gameSummaryTableView.dataSource = nil;
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.game.rounds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  static NSString *cellIdentifier = @"GameSummaryTableViewCell";
  GameSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  Round *round = [self.game.rounds objectAtIndex:indexPath.row];
  
  if (!cell) cell = [GameSummaryTableViewCell loadGameSummaryTableViewCell];
  [cell setRoundData:round];
  return cell;
  
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  return;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
