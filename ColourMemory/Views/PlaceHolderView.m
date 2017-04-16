//
//  PlaceHolderView.m
//  ColourMemory
//
//  Created by Shekhar on 12/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "PlaceHolderView.h"

@implementation PlaceholderData
@end

@implementation PlaceHolderView

- (id)initWithFrame:(CGRect)frame placeholderData:(PlaceholderData *)placeholderData
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self = [[[NSBundle mainBundle] loadNibNamed:@"PlaceHolderView" owner:self options:nil] objectAtIndex:0];
    self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.titleLabel.hidden = YES;

    self.actionButton.hidden = YES;
    self.iconImageView.hidden = YES;
    
    if (placeholderData.titleText) {
      self.titleLabel.hidden = NO;
      self.titleLabel.text = placeholderData.titleText;
    }
    if (placeholderData.buttonText) {
      self.actionButton.hidden = NO;
      [self.actionButton setTitle:placeholderData.buttonText forState:UIControlStateNormal];
    }
    if (placeholderData.imageName) {
      self.iconImageView.hidden = NO;
      [self.iconImageView setImage:[UIImage imageNamed:placeholderData.imageName]];
    }

  }
  return self;
}

- (IBAction)actionButtonTapped:(id)sender {
  if (self.actionButtonBlock) {
    self.actionButtonBlock();
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
