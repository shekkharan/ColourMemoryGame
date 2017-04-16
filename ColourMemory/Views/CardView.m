//
//  CardView.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "CardView.h"
#import "Card.h"
#import "AnimationHelper.h"

double kAnimationTime = 0.2;
double kCardDisappearTime = 0.2;
@implementation CardView

+ (CardView *)cardViewWithFrame:(CGRect)frame
                        andCard:(Card *)card
                        andType:(CardViewType)type
{
  CardView *cardView = [[[NSBundle mainBundle] loadNibNamed:@"CardView" owner:self options:nil] objectAtIndex:0];
  cardView.frame = frame;
  cardView.card = card;
  cardView.type = type;
  cardView.cardImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"colour%u",card.cardColour]];
  [cardView.card addObserver:cardView forKeyPath:@"type" options:0 context:nil];
  [cardView.card addObserver:cardView forKeyPath:@"gameEnded" options:0 context:nil];
  [cardView.card addObserver:cardView forKeyPath:@"animateAtReset" options:0 context:nil];
  [cardView setupType:cardView.card.type animated:NO];
  return cardView;
}

#pragma mark - setup

- (void)setupType:(CardType)type animated:(BOOL)animated
{
  switch (self.type) {
    case CardViewForGameBoard:
    {
      switch (self.card.type) {
        case CardTypeUnflipped:
        {
          [self unFlipCardWithAnimation:animated];
        }
          break;
        case CardTypeFlipped:
        {
          [self flipCardWithAnimation:animated];
        }
          break;
        case CardTypeInvisible:
        {
          [self makeCardInvisibleWithAnimation:animated];
        }
          break;
      }
    }
      break;
      
    case CardViewForGameSummary:
    {
      [self flipCardWithAnimation:animated];
    }
      break;
  }
}

#pragma mark - action methods

- (void)showAnimationAtGameOver
{
  [UIView transitionWithView:self
                    duration:1.0
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    self.cardBackgroundImageView.hidden = YES;
                    self.cardImageView.hidden = NO;
                  } completion:nil];
                  
}

- (void)showAnimationAgainAtGameOver
{
  [UIView transitionWithView:self
                    duration:0.2
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    self.cardBackgroundImageView.hidden = NO;
                    self.cardImageView.hidden = YES;
                  } completion:^(BOOL completion) {
                    [self showAnimationAtGameOver];
                  }];
}

- (void)flipCardWithAnimation:(BOOL)animated
{
  if (!animated) {
    self.cardBackgroundImageView.hidden = YES;
    self.cardImageView.hidden = NO;
  } else {
    self.flippingInProgress = YES;
    [UIView transitionWithView:self
                      duration:kAnimationTime
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                      self.cardBackgroundImageView.hidden = YES;
                      self.cardImageView.hidden = NO;
                    } completion:^(BOOL completion) {
                      if (self.flipDidCompleteBlock) {
                        self.flipDidCompleteBlock();
                      }
                      self.flippingInProgress = NO;
                    }];
  }
}

- (void)unFlipCardWithAnimation:(BOOL)animated
{
  if (!animated) {
    self.cardBackgroundImageView.hidden = NO;
    self.cardImageView.hidden = YES;
  } else {
    self.flippingInProgress = YES;
    [UIView transitionWithView:self
                      duration:kAnimationTime
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                      self.cardBackgroundImageView.hidden = NO;
                      self.cardImageView.hidden = YES;
                    } completion:^(BOOL completion) {
                      if (self.unflipDidCompleteBlock) {
                        self.unflipDidCompleteBlock();
                      }
                      self.flippingInProgress = NO;
                    }];
  }
}

- (void)makeCardInvisibleWithAnimation:(BOOL)animated
{
  if (!animated) {
    self.cardBackgroundImageView.hidden = YES;
    self.cardImageView.hidden = YES;
  } else {
    self.flippingInProgress = YES;
    [UIView animateWithDuration:0.3/1.5 animations:^{
      self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.3/2 animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
      } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
          self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
          [UIView animateWithDuration:kCardDisappearTime animations:^{
            self.alpha = 0.0;
          }completion:^(BOOL finished) {
            if (self.unflipDidCompleteBlock) {
              self.unflipDidCompleteBlock();
            }
            self.flippingInProgress = NO;
          }];
        }];
      }];
    }];
  }
}

- (void)showCardResetAnimation
{
  [UIView animateWithDuration:0.3/1.5 animations:^{
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.3/2 animations:^{
      self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.3/2 animations:^{
        self.transform = CGAffineTransformIdentity;
      } completion:^(BOOL finished) {
      }];
    }];
  }];
}

#pragma mark - KVO methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"type"])
  {
    if (object == self.card) {
      [self setupType:self.card.type animated:YES];
    }
  }
  
  if ([keyPath isEqualToString:@"gameEnded"]) {
    BOOL gameEnded = object;
    if (gameEnded) {
      self.alpha = 1.0;
      [self showAnimationAtGameOver];
    }
  }
  
  if ([keyPath isEqualToString:@"animateAtReset"]) {
    [self showCardResetAnimation];
  }
}

- (void)dealloc
{
  [self.card removeObserver:self forKeyPath:@"type"];
  [self.card removeObserver:self forKeyPath:@"gameEnded"];
  [self.card removeObserver:self forKeyPath:@"animateAtReset"];
}

@end
