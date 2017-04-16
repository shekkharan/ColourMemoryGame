//
//  UIManager.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "UIManager.h"
#import "AppDelegate.h"
#import "GameViewController.h"
#import "TutorialViewController.h"
#import "AnimationHelper.h"
#import "UIColor+AppColors.h"

#define kOnBoardingDone @"OnBoardingDone"
#define OnBoardingDone [[NSUserDefaults standardUserDefaults] boolForKey:kOnBoardingDone]

static UIManager *instance;

@interface UIManager()
{
    UIWindow *mainWindow;
}

@end

@implementation UIManager

#pragma mark -
#pragma mark Intialization
- (id) init {
  if (self = [super init])
  {
    mainWindow = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window;
    mainWindow.backgroundColor = [UIColor whiteColor];
    return self;
  }
  return nil;
}

+ (UIManager *)sharedInstance
{
  @synchronized([UIManager class]) {
    
    if ( instance == nil ) {
      instance = [[UIManager alloc] init];
    }
  }
  return instance;
}

- (void)launchApplication
{
  if (!OnBoardingDone) {
    [self launchTutorial];
  } else {
    [self launchGame];
  }
}

- (void)launchTutorial
{
  mainWindow.rootViewController =  [self tutorialViewController];
  [mainWindow makeKeyAndVisible];
}

- (void)launchGame
{
  if ([[GameManager sharedInstance] activeGame]) {
    mainWindow.rootViewController =  [GameViewController gameViewControllerWithState:GameViewControllerStateResumeGame];
  } else {
    mainWindow.rootViewController =  [GameViewController gameViewControllerWithState:GameViewControllerStateStartGame];
  }
  
  [mainWindow makeKeyAndVisible];
  [AnimationHelper showViewWithAnimation:mainWindow.rootViewController.view withDuration:0.4];
}

- (void)launchGameFromTutorial
{
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kOnBoardingDone];
  mainWindow.rootViewController =  [GameViewController gameViewControllerWithState:GameViewControllerStateJustAfterOnboarding];
  [mainWindow makeKeyAndVisible];
  [AnimationHelper showViewWithAnimation:mainWindow.rootViewController.view withDuration:0.2];
}

+ (UIViewController *)gameViewController {
  return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GameViewController"];
}

- (UIViewController *)tutorialViewController {
  return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TutorialViewController"];
}

+ (UIViewController *)saveGameViewController
{
  return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SaveGameViewController"];
}

+ (UIViewController *)highScoresViewController
{
  return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HighScoresViewController"];
}

@end
