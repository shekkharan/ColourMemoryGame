//
//  Game.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "Game.h"

@implementation Game

- (id)initWithCards:(NSArray *)cards
{
  self = [super init];
  if (self)
  {
    _cards = cards;
    _totalScore = 0;
    _rounds = [NSMutableArray array];
    _numberOfMatches = 0;
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:self.player forKey:@"player"];
  [encoder encodeObject:self.cards forKey:@"cards"];
  [encoder encodeObject:self.rounds forKey:@"rounds"];
  [encoder encodeInteger:self.totalScore forKey:@"totalScore"];
  [encoder encodeInteger:self.numberOfMatches forKey:@"numberOfMatches"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if (self)
  {
    _player = [decoder decodeObjectForKey:@"player"];
    _cards = [decoder decodeObjectForKey:@"cards"];
    _rounds = [decoder decodeObjectForKey:@"rounds"];
    _totalScore = [decoder decodeIntegerForKey:@"totalScore"];
    _numberOfMatches = [decoder decodeIntegerForKey:@"numberOfMatches"];
  }
  return self;
}

- (Round *)currentRound
{
  return [_rounds lastObject];
}

@end

@implementation Round

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:self.firstCard forKey:@"firstCard"];
  [encoder encodeObject:self.secondCard forKey:@"secondCard"];
  [encoder encodeInteger:self.points forKey:@"points"];
  [encoder encodeInteger:self.number forKey:@"number"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if (self)
  {
    _firstCard = [decoder decodeObjectForKey:@"firstCard"];
    _secondCard = [decoder decodeObjectForKey:@"secondCard"];
    _points = [decoder decodeIntegerForKey:@"points"];
    _number = [decoder decodeIntegerForKey:@"number"];
  }
  return self;
}

@end