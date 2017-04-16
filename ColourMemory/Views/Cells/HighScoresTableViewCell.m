//
//  HighScoresTableViewCell.m
//  ColourMemory
//
//  Created by Shekhar on 12/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "HighScoresTableViewCell.h"
#import "Player.h"
#import "UIColor+AppColors.h"
#import "UIView+RoundEdgeAndBorder.h"

@implementation HighScoresTableViewCell

- (void)awakeFromNib {
  // Initialization code
  [self.containerView maskRoundCorners:UIRectCornerAllCorners radius:5];
}

+ (HighScoresTableViewCell *)loadHighScoresTableViewCell
{
  HighScoresTableViewCell *highScoresTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"HighScoresTableViewCell" owner:nil options:nil] objectAtIndex:0];
  return highScoresTableViewCell;
}

- (void)setGameData:(Game *)game
{
  if (game.totalScore < 0) {
    self.pointsLabel.textColor = [UIColor appRedColor];
    self.pointsLabel.text = [NSString stringWithFormat:@"%ld",(long)game.totalScore];
  } else {
    self.pointsLabel.text = [NSString stringWithFormat:@"+%ld",(long)game.totalScore];
    self.pointsLabel.textColor = [UIColor appGreenColor];
  }
  
  self.playerNameLabel.text = [NSString stringWithFormat:@"%@",game.player.name];
  self.rankLabel.text = [NSString stringWithFormat:@"%ld.",(long)game.rank];
}
@end
