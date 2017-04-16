//
//  GameManager.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "GameManager.h"
#import "PersistenceManager.h"
#import "Game.h"
#import "Card.h"
#import "Message.h"

@interface GameManager ()
{
  PersistenceManager *persistenceManager;
}

@property (nonatomic,strong) Game *activeGame;

@end

@implementation GameManager
@synthesize messageBoardManager,scoreManager;

- (id)init
{
  self = [super init];
  if (self) {
    persistenceManager = [[PersistenceManager alloc] init];
    Message *message = [[Message alloc] init];
    messageBoardManager = [[MessageBoardManager alloc] initWithMessage:message];
    scoreManager = [[ScoreManager alloc] init];
  }
  return self;
}

+ (GameManager *)sharedInstance
{
  static GameManager *_sharedInstance = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    _sharedInstance = [[GameManager alloc] init];
  });
  return _sharedInstance;
}

#pragma mark - New Game methods

- (NSArray *)getCardsForNewGame
{
  return [persistenceManager shuffledCardStack];
}

- (Game *)startNewGame:(BOOL)onBoarding
{
  NSArray *cardsForNewGame = [self getCardsForNewGame];
  _activeGame = [[Game alloc] initWithCards:cardsForNewGame];
  [self startNewRound];
  [persistenceManager saveGame:_activeGame withType:SaveNewGame];
  [messageBoardManager showNewGameMessage:onBoarding];
  scoreManager.activeGame = _activeGame;
  return _activeGame;
}
- (Game *)startNewGamePostOnBoarding
{
  return [self startNewGame:YES];
}

- (Game *)startNewGame
{
  return [self startNewGame:NO];
}


- (void)resumeGame
{
  if (!self.activeGame.currentRound.firstCard && !self.activeGame.currentRound.secondCard) {
    [messageBoardManager showResumeGameRoundFirstCardNotPickedMessage:self.activeGame.currentRound];
  } else {
    [messageBoardManager showResumeGameRoundFirstCardPickedMessage:self.activeGame.currentRound];
  }
}

#pragma mark - Active Game methods

- (Game *)activeGame
{
  if (!_activeGame) {
    _activeGame = [persistenceManager getActiveGame];
  }
  scoreManager.activeGame = _activeGame;
  return _activeGame;
}

- (void)startNewRound
{
  Round *round = [[Round alloc] init];
  if (!self.activeGame.rounds) {
    _activeGame.rounds = [NSMutableArray array];
  }
  Round *lastRound = (Round *)[_activeGame.rounds lastObject];
  if (lastRound) {
    if (lastRound.firstCard && lastRound.secondCard) {
      [_activeGame.rounds addObject:round];
      round.number = _activeGame.rounds.count;
      if (round.number > 1) {
        [messageBoardManager showNewRoundMessage];
      }
    } else return;
  } else {
    [_activeGame.rounds addObject:round];
    round.number = _activeGame.rounds.count;
  }
  [persistenceManager saveGame:self.activeGame withType:SaveNewRound];
}

- (void)endCurrentRound
{
  Round *round = self.activeGame.currentRound;
  if (round.points == kSuccessPoints) {
    round.firstCard.type = CardTypeInvisible;
    round.secondCard.type = CardTypeInvisible;
  } else {
    round.firstCard.type = CardTypeUnflipped;
    round.secondCard.type = CardTypeUnflipped;
  }
}

- (void)flipCard:(Card *)card withBlock:(FlipCardResultBlock)flipCardResultBlock
{
  if (self.activeGame.currentRound.firstCard) {
    if (_activeGame.currentRound.firstCard == card) {
      [messageBoardManager showSameCardFlipMessage];
      return;
    }
    _activeGame.currentRound.secondCard = card;
    if (flipCardResultBlock) {
      Card *firstcard = _activeGame.currentRound.firstCard;
      Card *secondCard = _activeGame.currentRound.secondCard;
      if (secondCard.cardColour == firstcard.cardColour) {
        if (_activeGame.numberOfMatches == kNumberOfColours - 1) {
          [messageBoardManager showGameWonMessage];
          flipCardResultBlock(FlipCardResultGameWon,_activeGame.currentRound);
        } else {
          [messageBoardManager showFlippedCardsMatchedMessage];
          flipCardResultBlock(FlipCardResultHasMatched,_activeGame.currentRound);
        }
        [scoreManager addCardsMatchPoints];
      } else {
        [messageBoardManager showFlippedCardsNotMatchedMessage];
        flipCardResultBlock(FlipCardResultNoMatch,_activeGame.currentRound);
        [scoreManager minusCardsNotMatchedPoints];
      }
    }
  } else {
    _activeGame.currentRound.firstCard = card;
    [messageBoardManager showFirstCardFlippedMessage];
  }
  [persistenceManager saveGame:_activeGame withType:SaveCardFlip];
}

- (void)quitActiveGame
{
  _activeGame = nil;
  [persistenceManager cancelActiveGame];
}

#pragma mark - UnFinished Game methods

- (void)saveUnFinishedGame
{
  [persistenceManager saveGame:self.activeGame withType:SaveUnfinishedGame];
  _activeGame = nil;
}

#pragma mark - Finished Game methods

- (void)saveFinishedGame:(GameSaveBlock)saveBlock
{
  if (self.activeGame.player) {
    [persistenceManager saveGame:_activeGame withType:SaveFinishedGame];
    _activeGame = nil;
    if (saveBlock) {
      saveBlock(YES);
      return;
    }
  }
  if (saveBlock) {
    saveBlock(NO);
  }
}

- (NSArray *)gamesSortedByRanking
{
  NSArray *finishedGames = [persistenceManager getFinishedGames];
  NSMutableArray *sortedFinishedGames = [NSMutableArray arrayWithArray:finishedGames];
  NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"totalScore" ascending:NO];
  [sortedFinishedGames sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
  return sortedFinishedGames;
}

#pragma mark - Player methods

- (NSArray *)playerslist
{
  return [persistenceManager getPlayersList];
}

@end
