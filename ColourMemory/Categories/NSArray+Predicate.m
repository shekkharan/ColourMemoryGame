//
//  NSArray+Predicate.m
//  ColourMemory
//
//  Created by Shekhar on 11/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "NSArray+Predicate.h"

@implementation NSArray (Predicate)

- (NSArray *)getAllItemsMatchingPredicate:(NSPredicate *)predicate
{
  return [self filteredArrayUsingPredicate:predicate];
}

- (NSArray *)getAllItemsMatchingPredicateKindOfClass:(Class)desiredClass
{
  return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    return [evaluatedObject isKindOfClass:desiredClass];
  }]];
}

- (id)firstObjectMatchingPredicate:(NSPredicate *)predicate
{
  return [self matchPredicate:predicate withEnumerator:[self objectEnumerator]];
}

- (id)lastObjectMatchingPredicate:(NSPredicate *)predicate
{
  return [self matchPredicate:predicate withEnumerator:[self reverseObjectEnumerator]];
}

- (id)matchPredicate:(NSPredicate *)predicate withEnumerator:(NSEnumerator *)en
{
  id current = [en nextObject];
  while (current)
  {
    if ([predicate evaluateWithObject:current])
    {
      return current;
    }
    current = [en nextObject];
  }
  return nil;
}

- (BOOL)stringExistsInArray:(NSString *)searchString andProperty:(NSString *)property
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ == %@",property,searchString];
  id object = [self lastObjectMatchingPredicate:predicate];
  if (object) return YES;
  return NO;
}

- (BOOL)stringExistsInArray:(NSString *)searchString;
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches[c] %@",searchString];
  NSArray *results = [self filteredArrayUsingPredicate:predicate];
  if ([results count]) return YES;
  return NO;
}

- (NSArray *)containingStringsInArray:(NSString *)searchString;
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[c] %@",searchString];
  NSArray *matches = [self getAllItemsMatchingPredicate:predicate];
  return matches;
}

@end
