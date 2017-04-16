//
//  PersistenceManager.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "PersistenceManager.h"
#import "Card.h"
#import "Game.h"
#import "NSMutableArray+Shuffle.h"
#import "NSArray+Predicate.h"
#import "Player.h"

#define CACHE_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

NSString * const kCardStackFileName = @"CardStack";
NSString * const kActiveGameFileName = @"ActiveGame";
NSString * const kSavedGamesFileName = @"SavedGames";
NSString * const kFinishedGamesFileName = @"FinishedGames";
NSString * const kPlayersList = @"PlayersList";

@interface PersistenceManager ()
{
  NSMutableArray *cardStack;
  NSMutableArray *savedGames;
  NSMutableArray *finishedGames;
  NSMutableArray *players;
  NSInteger numberOfColours;
}
@end

@implementation PersistenceManager

- (id)init
{
  self = [super init];
  if (self) {
    cardStack = [self unarchiveObjectFromFile:kCardStackFileName];
    if (!cardStack)
    {
      cardStack = [NSMutableArray array];
      for (int i = 0; i < kNumberOfColours; i++) {
        Card *firstCard = [[Card alloc] initWithIndex:i];
        Card *secondCard = [[Card alloc] init];
        secondCard = [secondCard copyFromCard:firstCard];
        [cardStack addObject:firstCard];
        [cardStack addObject:secondCard];
      }
      [self saveCards];
    }
  }
  return self;
}

#pragma mark - Card Persistence methods

- (void)saveCards
{
  [self archiveObject:cardStack fileName:kCardStackFileName];
}

- (NSMutableArray *)shuffledCardStack
{
  NSData *buffer;
  buffer = [NSKeyedArchiver archivedDataWithRootObject: [cardStack shuffledArray]];
  NSMutableArray *shuffledCardStack = [NSKeyedUnarchiver unarchiveObjectWithData:buffer];
  return shuffledCardStack;
}

#pragma mark - Game Persistence methods

- (void)saveGame:(Game *)game withType:(SaveGameType)type;
{
  switch (type) {
    case SaveNewRound:
    {
      [self archiveObject:game fileName:kActiveGameFileName];
    }
      break;
    case SaveNewGame:
    {
      [self archiveObject:game fileName:kActiveGameFileName];
    }
      break;
    case SaveCardFlip:
    {
      [self archiveObject:game fileName:kActiveGameFileName];
    }
      break;
    case SaveUnfinishedGame:
    {
      savedGames = [self unarchiveObjectFromFile:kSavedGamesFileName];
      if (savedGames && savedGames.count) {
        [savedGames addObject:game];
      } else {
        savedGames = [NSMutableArray array];
        [savedGames addObject:game];
      }
      [self removeObjectForFileWithFileName:kActiveGameFileName];
      [self archiveObject:savedGames fileName:kSavedGamesFileName];
    }
      break;
    case SaveFinishedGame:
    {
      finishedGames = [self unarchiveObjectFromFile:kFinishedGamesFileName];
      if (finishedGames && finishedGames.count) {
        [finishedGames addObject:game];
      } else {
        finishedGames = [NSMutableArray array];
        [finishedGames addObject:game];
      }
      [self savePlayer:game.player];
      [self removeObjectForFileWithFileName:kActiveGameFileName];
      [self archiveObject:finishedGames fileName:kFinishedGamesFileName];
    }
      break;
  }
}

- (Game *)getActiveGame
{
  return (Game *)[self unarchiveObjectFromFile:kActiveGameFileName];
}

- (void)cancelActiveGame
{
  [self removeObjectForFileWithFileName:kActiveGameFileName];
}

- (NSArray *)getPlayersList
{
  players = [self unarchiveObjectFromFile:kPlayersList];
  if (!players) {
    players = [NSMutableArray array];
  }
  return (NSArray *)players;
}

- (NSArray *)getFinishedGames
{
  finishedGames = [self unarchiveObjectFromFile:kFinishedGamesFileName];
  if (!finishedGames) {
    finishedGames = [NSMutableArray array];
  }
  return (NSArray *)finishedGames;
}

- (void)savePlayer:(Player *)player
{
  if (!players) {
    players = [NSMutableArray array];
  }
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",player.name];

  if (![players firstObjectMatchingPredicate:predicate]) {
    [players addObject:player];
  }
  [self archiveObject:players fileName:kPlayersList];
}

- (void)savePlayersList
{
  [self archiveObject:players fileName:kPlayersList];
}

#pragma mark - File Read/Write methods

- (BOOL)archiveObject:(id)object fileName:(NSString *)fileName
{
  NSString *filePath = [NSString stringWithFormat:@"%@/%@.data",CACHE_DIRECTORY,fileName];
  
  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
  {
    [[NSFileManager defaultManager]createFileAtPath:filePath contents:nil attributes:nil];
  }
  
  return [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

- (id)unarchiveObjectFromFile:(NSString *)fileName
{
  NSString *filePath = [NSString stringWithFormat:@"%@/%@.data",CACHE_DIRECTORY,fileName];
  
  return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (BOOL)removeObjectForFileWithFileName:(NSString *)fileName
{
  NSString *filePath = [NSString stringWithFormat:@"%@/%@.data",
                        CACHE_DIRECTORY,fileName];
  
  NSError *error;
  
  return [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}

@end
