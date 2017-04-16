//
//  ScoreView.m
//  ColourMemory
//
//  Created by Shekhar on 10/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "ScoreView.h"
#import "Game.h"

@interface ScoreView ()
@property (strong, nonatomic) Game *game;
@end

@implementation ScoreView

+ (ScoreView *)scoreViewWithFrame:(CGRect)frame andGame:(Game *)game
{
  ScoreView *scoreView = [[[NSBundle mainBundle] loadNibNamed:@"ScoreView" owner:self options:nil] objectAtIndex:0];
  scoreView.game = game;
  scoreView.frame = frame;
  [scoreView.game addObserver:scoreView forKeyPath:@"totalScore" options:0 context:nil];
  [scoreView updateScore:NO];
  return scoreView;
}

#pragma mark - action methods

- (void)updateScore:(BOOL)animated
{
  self.scoreLabel.text = @"";
  if (!self.game.totalScore) {
    self.scoreLabel.text = @"0";
    return;
  }
  self.numberOfMatchesLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.game.numberOfMatches,(long)kNumberOfColours];
  self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)self.game.totalScore];
  if (animated) {
    [UIView animateWithDuration:0.3/1.5 animations:^{
      self.scoreLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:0.3/2 animations:^{
        self.scoreLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
      } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
          self.scoreLabel.transform = CGAffineTransformIdentity;
        }];
      }];
    }];
  }
}

#pragma mark - KVO methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"totalScore"]) {
    [self updateScore:YES];
  }
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
