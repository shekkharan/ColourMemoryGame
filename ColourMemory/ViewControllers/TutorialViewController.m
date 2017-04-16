//
//  TutorialViewController.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "TutorialViewController.h"
#import "UIView+RoundEdgeAndBorder.h"
#import "UIManager.h"
#import "APRoundedButton.h"

@interface TutorialViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getMeStartedButton;
@property (weak, nonatomic) IBOutlet UIView *tutorialView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rulesLabel;
@property (weak, nonatomic) IBOutlet APRoundedButton *geMeStartedButton;

@end

@implementation TutorialViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tutorialView maskRoundCorners:UIRectCornerAllCorners radius:5];
  //[self.getMeStartedButton maskRoundCorners:UIRectCornerAllCorners radius:3];
  //[self.getMeStartedButton addAllBorderWithColor:[UIColor blackColor] andWidth:1];
}

- (IBAction)getMeStartedButtonTapped:(id)sender {
  
  CGFloat shrinkDuration = 1 * 0.3;
  CGFloat growDuration = 0.7;
  [UIView animateWithDuration:shrinkDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.75, 0.75);
    self.tutorialView.transform = scaleTransform;
  } completion:^(BOOL finished) {
    self.geMeStartedButton.alpha = 0;
    self.rulesLabel.text = @"";
    self.welcomeLabel.text = @"";
    [UIView animateWithDuration:growDuration animations:^{
      CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
      self.tutorialView.transform = scaleTransform;
      self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
      [[UIManager sharedInstance] launchGameFromTutorial];
    }];
  }];

  
}

@end
