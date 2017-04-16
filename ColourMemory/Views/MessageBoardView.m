//
//  MessageBoardView.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "MessageBoardView.h"
#import "Game.h"
#import "Message.h"
#import "AnimationHelper.h"

NSString *kBlank = @"";

@implementation MessageBoardView

+ (MessageBoardView *)messageBoardViewWithFrame:(CGRect)frame andMessage:(Message *)message
{
  MessageBoardView *messageBoardView = [[[NSBundle mainBundle] loadNibNamed:@"MessageBoardView" owner:self options:nil] objectAtIndex:0];
  messageBoardView.message = message;
  messageBoardView.frame = frame;
  [messageBoardView.message addObserver:messageBoardView forKeyPath:@"details" options:0 context:nil];
  [messageBoardView.message addObserver:messageBoardView forKeyPath:@"title" options:0 context:nil];
  [messageBoardView.message addObserver:messageBoardView forKeyPath:@"roundNumber" options:0 context:nil];
  [messageBoardView showMessage];
  return messageBoardView;
}

- (void)showMessage
{
  [self sizeToFit];
  self.roundNumberLabel.text = kBlank;
  self.messageTitleLabel.text = kBlank;
  self.messageDetailsLabel.text = kBlank;
  
  if (self.message.roundNumber) {
    [self changeMessageRoundNumberLabel:YES];
  }
  
  if (self.message.title) {
    [self changeMessageTitleLabel:YES];
  }
  
  if (self.messageDetailsLabel) {
    [self changeMessageDetailsLabel:YES];
  }
}

- (void)changeMessageTitleLabel:(BOOL)animated
{
  self.messageTitleLabel.text = @"";
  self.messageTitleLabel.text = self.message.title;
  if (animated) {
    [UIView animateWithDuration:0.3/1.5 animations:^{
      self.messageTitleLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.3/2 animations:^{
        self.messageTitleLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
      } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
          self.messageTitleLabel.transform = CGAffineTransformIdentity;
        }];
      }];
    }];
  }
}

- (void)changeMessageDetailsLabel:(BOOL)animated
{
  self.messageDetailsLabel.text = @"";
  if (animated) {
    [AnimationHelper showViewWithAnimation:self.messageDetailsLabel withDuration:0.4];
  }
  self.messageDetailsLabel.text = self.message.details;
}

- (void)changeMessageRoundNumberLabel:(BOOL)animated
{
  self.roundNumberLabel.text = @"";
  if (self.message.roundNumber) {
    if (animated) {
      self.roundNumberLabel.alpha = 0.0;
      self.roundNumberLabel.textColor = [UIColor clearColor];
      self.roundNumberLabel.transform = CGAffineTransformMakeTranslation(0.0f, -self.roundNumberLabel.frame.size.height);
      self.roundNumberLabel.text = [NSString stringWithFormat:@"Round %ld",(long)self.message.roundNumber];
      [UIView animateWithDuration:0.6f animations:^{
        self.roundNumberLabel.alpha = 1.0;
        self.roundNumberLabel.transform = CGAffineTransformIdentity;
        self.roundNumberLabel.textColor = [UIColor blackColor];
      }];
    } else {
      self.roundNumberLabel.text = [NSString stringWithFormat:@"Round %ld",(long)self.message.roundNumber];
    }
  }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"title"]) {
      [self changeMessageTitleLabel:YES];
  }
  
  if ([keyPath isEqualToString:@"details"]) {
    [self changeMessageDetailsLabel:YES];
  }
  if ([keyPath isEqualToString:@"roundNumber"]) {
    [self changeMessageRoundNumberLabel:YES];
  }
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
