//
//  ScoreManager.h
//  ColourMemory
//
//  Created by Shekhar on 10/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;

extern const NSInteger kSuccessPoints;
extern const NSInteger kPenaltyPoints;

@interface ScoreManager : NSObject

@property (nonatomic,strong) Game *activeGame;

- (void)addCardsMatchPoints;
- (void)minusCardsNotMatchedPoints;

@end
