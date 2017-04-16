//
//  GameSummaryTableViewCell.h
//  ColourMemory
//
//  Created by Shekhar on 11/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"
#import "Game.h"

@interface GameSummaryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *roundNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstCardView;
@property (weak, nonatomic) IBOutlet UIImageView *secondCardView;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

+ (GameSummaryTableViewCell *)loadGameSummaryTableViewCell;
- (void)setRoundData:(Round *)round;

@end
