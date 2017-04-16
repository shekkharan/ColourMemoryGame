//
//  GameBoardCollectionViewCell.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "GameBoardCollectionViewCell.h"

@implementation GameBoardCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (GameBoardCollectionViewCell *)loadGameBoardCollectionViewCell
{
  GameBoardCollectionViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"GameBoardCollectionViewCell" owner:nil options:nil] objectAtIndex:0];
  return cell;
}

- (void)setCardData:(Card *)card
{
  self.cardView = [CardView cardViewWithFrame:self.cardView.frame andCard:card andType:CardViewForGameBoard];
  [self.contentView addSubview:self.cardView];
}

@end
