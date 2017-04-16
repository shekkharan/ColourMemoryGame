//
//  GameSummaryTableViewCell.m
//  ColourMemory
//
//  Created by Shekhar on 11/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "GameSummaryTableViewCell.h"
#import "UIView+RoundEdgeAndBorder.h"
#import "Card.h"
#import "UIColor+AppColors.h"

@implementation GameSummaryTableViewCell

- (void)awakeFromNib {
    // Initialization code
  [self.containerView maskRoundCorners:UIRectCornerAllCorners radius:8];
}

+ (GameSummaryTableViewCell *)loadGameSummaryTableViewCell
{
  GameSummaryTableViewCell *gameSummaryTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"GameSummaryTableViewCell" owner:nil options:nil] objectAtIndex:0];
  return gameSummaryTableViewCell;
}

- (void)setRoundData:(Round *)round
{
//  self.firstCardView = [CardView cardViewWithFrame:self.firstCardView.frame andCard:round.firstCard andType:CardViewForGameSummary];
//  self.secondCardView = [CardView cardViewWithFrame:self.secondCardView.frame andCard:round.secondCard andType:CardViewForGameSummary];
  self.firstCardView.image = [UIImage imageNamed:[NSString stringWithFormat:@"colour%u",round.firstCard.cardColour]];
  self.secondCardView.image = [UIImage imageNamed:[NSString stringWithFormat:@"colour%u",round.secondCard.cardColour]];
  if (round.points < 0) {
    self.pointsLabel.textColor = [UIColor appRedColor];
    self.pointsLabel.text = [NSString stringWithFormat:@"%ld",(long)round.points];
  } else {
    self.pointsLabel.text = [NSString stringWithFormat:@"+%ld",(long)round.points];
    self.pointsLabel.textColor = [UIColor appGreenColor];
  }
  
  [self.containerView addSubview:self.firstCardView];
  [self.containerView addSubview:self.secondCardView];
  
  self.roundNameLabel.text = [NSString stringWithFormat:@"Round %ld",(long)round.number];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
