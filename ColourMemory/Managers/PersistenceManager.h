//
//  PersistenceManager.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;

typedef enum {
  SaveNewRound,
  SaveNewGame,
  SaveCardFlip,
  SaveUnfinishedGame,
  SaveFinishedGame
}SaveGameType;

@interface PersistenceManager : NSObject

- (NSMutableArray *)shuffledCardStack;
- (void)saveGame:(Game *)game withType:(SaveGameType)type;
- (Game *)getActiveGame;
- (void)cancelActiveGame;
- (NSArray *)getPlayersList;
- (NSArray *)getFinishedGames;

@end
