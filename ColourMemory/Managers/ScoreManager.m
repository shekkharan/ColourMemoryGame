//
//  ScoreManager.m
//  ColourMemory
//
//  Created by Shekhar on 10/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "ScoreManager.h"
#import "Game.h"


const NSInteger kSuccessPoints = 2;
const NSInteger kPenaltyPoints = -1;

@interface ScoreManager ()

@end

@implementation ScoreManager

- (void)addCardsMatchPoints
{
  self.activeGame.numberOfMatches += 1;
  self.activeGame.currentRound.points = kSuccessPoints;
  self.activeGame.totalScore += kSuccessPoints;
  
}

- (void)minusCardsNotMatchedPoints
{
  self.activeGame.currentRound.points = kPenaltyPoints;
  self.activeGame.totalScore += kPenaltyPoints;
}

@end
