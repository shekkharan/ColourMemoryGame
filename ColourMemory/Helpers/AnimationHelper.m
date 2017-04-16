//
//  AnimationHelper.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationHelper.h"

@implementation AnimationHelper

+ (void)showViewWithAnimation:(UIView *)view withDuration:(NSTimeInterval)duration
{
    view.hidden = YES;
    
    dispatch_time_t showTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
    dispatch_after(showTime, dispatch_get_main_queue(), ^(void)
                   {
                       [AnimationHelper showAnimationOnView:view withDuration:duration];
                           view.hidden = NO;
                   });
}

+ (void)showAnimationOnView:(UIView *)view withDuration:(NSTimeInterval)duration
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = duration;
    [view.layer addAnimation:animation forKey:nil];
}

+ (void)showAnimationOnView:(UIView *)view withDistance:(CGFloat)distance withAnimationType:(RMAnimationType)animationType withAnimationOption:(UIViewAnimationOptions)animationOption withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay onCompletion:(void(^)(void))completion
{
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         switch (animationType) {
                             case kRightToLeft:
                             {
                                 view.center = CGPointMake(view.center.x + distance, view.center.y);
                             }
                                 break;
                             case kLeftToRight:
                             {
                                 view.center = CGPointMake(view.center.x - distance, view.center.y);
                             }
                                 break;
                             case kTopToBottom:
                             {
                                 view.center = CGPointMake(view.center.x, view.center.y + distance);
                             }
                                 break;
                             case kBottomToTop:
                             {
                                 view.center = CGPointMake(view.center.x, view.center.y - distance);
                             }
                                 break;
                                 
                             default:
                                 break;
                         }
                     }
                     completion:^(BOOL finished){
                          completion();                         
                     }];
   
}

@end
