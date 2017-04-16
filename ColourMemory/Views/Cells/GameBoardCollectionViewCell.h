//
//  GameBoardCollectionViewCell.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@class Card;

@interface GameBoardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet CardView *cardView;
+ (GameBoardCollectionViewCell *)loadGameBoardCollectionViewCell;
- (void)setCardData:(Card *)card;

@end
