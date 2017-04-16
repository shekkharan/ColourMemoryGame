//
//  GameManager.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceManager.h"
#import "MessageBoardManager.h"
#import "ScoreManager.h"

@class Round;
@class Game;
@class Card;

typedef enum {
  FlipCardResultNoMatch,
  FlipCardResultHasMatched,
  FlipCardResultGameWon
}FlipCardResultType;

typedef void (^GameSaveBlock)(BOOL success);
typedef void (^FlipCardResultBlock)(FlipCardResultType result, Round *round);

@interface GameManager : NSObject

@property (nonatomic,strong) MessageBoardManager *messageBoardManager;
@property (nonatomic,strong) ScoreManager *scoreManager;

+ (GameManager *)sharedInstance;
- (Game *)activeGame;
- (Game *)startNewGamePostOnBoarding;
- (Game *)startNewGame;
- (void)resumeGame;
- (void)saveFinishedGame:(GameSaveBlock)saveBlock;
- (void)quitActiveGame;
- (void)startNewRound;
- (void)endCurrentRound;
- (NSArray *)playerslist;
- (NSArray *)gamesSortedByRanking;
- (void)flipCard:(Card *)card withBlock:(FlipCardResultBlock)flipCardResultBlock;

@end
