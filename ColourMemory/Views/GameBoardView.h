//
//  BoardView.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Game;
@class Card;

typedef void (^CardSelectBlock)(Card *card, BOOL isSameCard);
typedef void (^UnFlipCardsCompletedBlock)();

@interface GameBoardView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) Game *game;
@property (weak, nonatomic) IBOutlet UICollectionView *gameBoardCollectionView;
@property (nonatomic,copy) CardSelectBlock cardSelectBlock;
@property (nonatomic,copy) UnFlipCardsCompletedBlock unFlipCardsCompletedBlock;

+ (GameBoardView *)gameBoardViewWithFrame:(CGRect)frame andGame:(Game *)game;
- (void)resetBoardWithNewGame:(Game *)game;
- (void)showGameOver;
- (void)showResetAnimation;

@end
