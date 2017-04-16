//
//  TableViewWithPlaceholder.m
//  ColourMemory
//
//  Created by Shekhar on 12/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "TableViewWithPlaceholder.h"

@implementation TableViewWithPlaceholder

@synthesize placeholderView;

- (BOOL)isEmpty
{
  for (int i = 0; i < self.numberOfSections; i++) {
    if ([self numberOfRowsInSection:i] > 0) {
      return NO;
    }
  }
  return YES;
}

- (void)updatePlaceholderView
{
  const CGRect rect = (CGRect){CGPointZero,self.frame.size};
  placeholderView.frame = rect;
  
  const BOOL shouldShowPlaceholderView = self.isEmpty;
  const BOOL placeholderViewShown = placeholderView.superview != nil;
  
  if (shouldShowPlaceholderView == placeholderViewShown) return;
  
  CATransition *animation = [CATransition animation];
  [animation setDuration:0.3];
  [animation setType:kCATransitionFade];
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
  [[self layer] addAnimation:animation forKey:kCATransitionReveal];
  
  if (shouldShowPlaceholderView)
    [self addSubview:placeholderView];
  else
    [placeholderView removeFromSuperview];
}

- (void)setPlaceholderView:(PlaceHolderView *)newView
{
  if (newView == placeholderView) return;
  
  UIView *oldView = placeholderView;
  placeholderView = newView;
  [oldView removeFromSuperview];
}

#pragma mark UIView

- (void)layoutSubviews
{
  [super layoutSubviews];
  [self updatePlaceholderView];
}

#pragma mark UITableView reload

- (void)reloadData
{
  [self updatePlaceholderView];
  [super reloadData];
}

@end

