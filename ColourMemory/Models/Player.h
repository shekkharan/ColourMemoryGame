//
//  Player.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic,strong) NSString *name;

- (id)initWithName:(NSString *)name;

@end
