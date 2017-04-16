//
//  AnimationHelper.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    kRightToLeft,
    kLeftToRight,
    kTopToBottom,
    kBottomToTop
}RMAnimationType;

@interface AnimationHelper : NSObject

+ (void)showAnimationOnView:(UIView *)view withDistance:(CGFloat)distance withAnimationType:(RMAnimationType)animationType withAnimationOption:(UIViewAnimationOptions)animationOption withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay onCompletion:(void(^)(void))completion;

+ (void)showAnimationOnView:(UIView *)view withDuration:(NSTimeInterval)duration;
+ (void)showViewWithAnimation:(UIView *)view withDuration:(NSTimeInterval)duration;

@end
