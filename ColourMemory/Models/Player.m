//
//  Player.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithName:(NSString *)name
{
  self = [super init];
  if (self)
  {
    _name = name;
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:self.name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if (self)
  {
    _name = [decoder decodeObjectForKey:@"name"];
  }
  return self;
}

@end
