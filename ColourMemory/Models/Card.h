//
//  Card.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Position;

typedef enum {
  CardColourZero,
  CardColourOne,
  CardColourTwo,
  CardColourThree,
  CardColourFour,
  CardColourFive,
  CardColourSix,
  CardColourSeven
}CardColour;

typedef enum {
  CardTypeUnflipped,
  CardTypeFlipped,
  CardTypeInvisible
}CardType;

@interface Card : NSObject <NSCoding>

@property (nonatomic,assign) CardColour cardColour;
@property (nonatomic,assign) CardType type;
@property (nonatomic,assign) NSInteger column;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) BOOL gameEnded;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,assign) BOOL animateAtReset;

- (Card *)copyFromCard:(Card *)card;

- (id)initWithIndex:(int)index;

@end
