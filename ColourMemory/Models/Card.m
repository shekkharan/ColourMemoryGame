//
//  Card.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "Card.h"

@implementation Card

- (id)initWithIndex:(int)index
{
  self = [super init];
  if (self)
  {
    _cardColour = (CardColour)index;
    _type = CardTypeUnflipped;
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeInt:self.cardColour forKey:@"cardColour"];
  [encoder encodeInt:self.type forKey:@"type"];
  [encoder encodeInteger:self.row forKey:@"row"];
  [encoder encodeInteger:self.column forKey:@"column"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if (self)
  {
    _cardColour = [decoder decodeIntForKey:@"cardColour"];
    _type = [decoder decodeIntForKey:@"type"];
    _row = [decoder decodeIntegerForKey:@"row"];
    _column = [decoder decodeIntegerForKey:@"column"];
  }
  return self;
}

- (Card *)copyFromCard:(Card *)card
{
  self.cardColour = card.cardColour;
  self.type = card.type;
  self.row = card.row;
  self.column = card.column;
  return self;
}

@end
