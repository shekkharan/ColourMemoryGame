//
//  UIView+RoundEdgeAndBorder.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (RoundEdgeAndBorder)

- (void)maskRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius;

- (void)addBottomBorderWithColor:(UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addLeftBorderWithColor:(UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addRightBorderWithColor:(UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addTopBorderWithColor:(UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addAllBorderWithColor:(UIColor *) color andWidth:(CGFloat) borderWidth;

@end
