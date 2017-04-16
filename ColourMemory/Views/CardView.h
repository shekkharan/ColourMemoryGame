//
//  CardView.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Card;

typedef enum {
  CardViewForGameBoard,
  CardViewForGameSummary
}CardViewType;

typedef void (^FlipDidCompleteBlock) ();
typedef void (^UnflipDidCompleteBlock) ();

@interface CardView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *cardBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (assign, nonatomic) BOOL flippingInProgress;
@property (strong, nonatomic) Card *card;
@property (assign, nonatomic) CardViewType type;

@property (copy, nonatomic) FlipDidCompleteBlock flipDidCompleteBlock;
@property (copy, nonatomic) UnflipDidCompleteBlock unflipDidCompleteBlock;

+ (CardView *)cardViewWithFrame:(CGRect)frame
                        andCard:(Card *)card
                        andType:(CardViewType)type;

@end
