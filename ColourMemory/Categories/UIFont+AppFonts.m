//
//  UIFont+AppFonts.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//


#import "UIFont+AppFonts.h"

@implementation UIFont (AppFonts)

+(UIFont*) lightAppFontOfSize:(int)size {
  
  return [UIFont fontWithName:@"Volkswagen-Light" size:size];
}

+(UIFont*) appFontOfSize:(int)size {
  
  return [UIFont fontWithName:@"Volkswagen-Regular" size:size];
}

+(UIFont*) mediumAppFontOfSize:(int)size {
    
    return [UIFont fontWithName:@"Volkswagen-Medium" size:size];
}

+(UIFont*) boldAppFontOfSize:(int)size {
    
    return [UIFont fontWithName:@"Volkswagen-Bold" size:size];
}

+(UIFont*) heavyAppFontOfSize:(int)size {
  
  return [UIFont fontWithName:@"Volkswagen-Heavy" size:size];
}

@end
