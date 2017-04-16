//
//  NSMutableArray+Shuffle.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

- (NSMutableArray *)shuffledArray
{
  NSMutableArray *shuffledArray;
  NSUInteger count = [self count];
  if (count < 1) return shuffledArray;
  for (NSUInteger i = 0; i < count - 1; ++i) {
    NSInteger remainingCount = count - i;
    NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
    [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    shuffledArray = [self copy];
  }
  return shuffledArray;
}

@end
