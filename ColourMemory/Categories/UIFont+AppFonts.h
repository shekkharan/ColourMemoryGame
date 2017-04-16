//
//  UIFont+AppFonts.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIFont (AppFonts)

+ (UIFont*)lightAppFontOfSize:(int)size;
+ (UIFont*)appFontOfSize:(int)size;
+ (UIFont*)mediumAppFontOfSize:(int)size;
+ (UIFont*)boldAppFontOfSize:(int)size;
+ (UIFont*)heavyAppFontOfSize:(int)size;

@end
