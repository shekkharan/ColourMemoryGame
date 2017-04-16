//
//  UIView+RoundEdgeAndBorder.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "UIView+RoundEdgeAndBorder.h"

@implementation UIView (RoundEdgeAndBorder)

- (void)maskRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    // To round all corners, we can just set the radius on the layer
    if ( corners == UIRectCornerAllCorners ) {
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = YES;
    } else {
        // If we want to choose which corners we want to mask then
        // it is necessary to create a mask layer.
        self.layer.mask = [self maskLayerWithCorners:corners radii:CGSizeMake(radius, radius) frame:self.bounds];
    }
}

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(self.frame.size.width, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

- (void)addAllBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
    
}

- (id)maskLayerWithCorners:(UIRectCorner)corners radii:(CGSize)radii frame:(CGRect)frame {
    
    // Create a CAShapeLayer
    CAShapeLayer *mask = [CAShapeLayer layer];
    
    // Set the frame
    mask.frame = frame;
    
    // Set the CGPath from a UIBezierPath
    mask.path = [UIBezierPath bezierPathWithRoundedRect:mask.bounds byRoundingCorners:corners cornerRadii:radii].CGPath;
    
    // Set the fill color
    mask.fillColor = [UIColor whiteColor].CGColor;
    
    return mask;
}

@end
