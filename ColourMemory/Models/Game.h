//
//  Game.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;
@class Card;
@class Round;

static const NSInteger kNumberOfColours = 8;

@interface Game : NSObject

@property (nonatomic,strong) Player *player;
@property (nonatomic,strong) NSArray *cards;
@property (nonatomic,strong) NSMutableArray *rounds;
@property (nonatomic,assign) NSInteger totalScore;
@property (nonatomic,assign) NSInteger numberOfMatches;
@property (nonatomic,assign) NSInteger rank;

- (id)initWithCards:(NSArray *)cards;
- (Round *)currentRound;

@end

@interface Round : NSObject

@property (nonatomic,strong) Card *firstCard;
@property (nonatomic,strong) Card *secondCard;
@property (nonatomic,assign) NSInteger points;
@property (nonatomic,assign) NSInteger number;

@end