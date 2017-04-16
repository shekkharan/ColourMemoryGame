//
//  Message.h
//  ColourMemory
//
//  Created by Shekhar on 10/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *details;
@property (assign, nonatomic) NSInteger roundNumber;

@end
