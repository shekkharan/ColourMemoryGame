//
//  UIColor+AppColors.m
//  ColourMemory
//
//  Created by Shekhar on 12/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (AppColors)

+ (UIColor *)appBlueColor
{
  return [UIColor colorWithRed:18.0/255.0 green:149.0/255.0 blue:229.0/255.0 alpha:1.0];
}

+ (UIColor *)appTranslucentWhiteColor
{
  return [UIColor colorWithWhite:1 alpha:0.8];
}

+ (UIColor *)appGreenColor
{
  return [UIColor colorWithRed:33.0/255.0 green:219.0/255.0 blue:35.0/255.0 alpha:1.0];
}

+ (UIColor *)appRedColor
{
  return [UIColor colorWithRed:255.0/255.0 green:0.0 blue:0.0 alpha:1.0];
}

@end
