//
//  NSArray+Predicate.h
//  ColourMemory
//
//  Created by Shekhar on 11/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Predicate)

- (NSArray *)getAllItemsMatchingPredicate:(NSPredicate *)predicate;
- (NSArray *)getAllItemsMatchingPredicateKindOfClass:(Class)desiredClass;
- (id)firstObjectMatchingPredicate:(NSPredicate *)predicate;
- (id)lastObjectMatchingPredicate:(NSPredicate *)predicate;
- (BOOL)stringExistsInArray:(NSString *)searchString andProperty:(NSString *)property;
- (BOOL)stringExistsInArray:(NSString *)searchString;
- (NSArray *)containingStringsInArray:(NSString *)searchString;
@end
