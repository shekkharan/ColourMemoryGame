//
//  GameSummaryView.h
//  ColourMemory
//
//  Created by Shekhar on 11/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Game;

@interface GameSummaryView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) Game *game;
@property (weak, nonatomic) IBOutlet UITableView *gameSummaryTableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsLabel;
- (void)showSummary;
+ (GameSummaryView *)gameSummaryViewWithFrame:(CGRect)frame andGame:(Game *)game;

@end
