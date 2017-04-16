//
//  CustomSegue.m
//  ColourMemory
//
//  Created by Shekhar on 10/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "CustomSegue.h"

@implementation CustomSegue

- (void)perform {
  
  UIViewController *source = (UIViewController *)self.sourceViewController;
  UIViewController *destination = (UIViewController *)self.destinationViewController;
  
  UIView *superView = [source.view superview];
  superView.backgroundColor = [UIColor colorWithRed:18.0/255.0 green:149.0/255.0 blue:229.0/255.0 alpha:1.0];
  
  CGRect f = source.view.frame;
  CGRect originalSourceRect = source.view.frame;
  f.origin.y = f.size.height;
  
  [UIView animateWithDuration:0.3 animations:^{
    source.view.frame = f;
    
  } completion:^(BOOL finished){
    source.view.alpha = 0.0f;
    destination.view.frame = f;
    destination.view.alpha = 0.0f;
    [[source.view superview] addSubview:destination.view];
    [UIView animateWithDuration:0.3 animations:^{
      
      destination.view.frame = originalSourceRect;
      destination.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
      
      source.view.alpha = 1.0f;
      [source.navigationController pushViewController:destination animated:NO];
      [destination.view removeFromSuperview];
    }];
  }];
}

@end
