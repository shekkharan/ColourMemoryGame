//
//  GameViewController.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameManager.h"

typedef enum {
  GameViewControllerStateJustAfterOnboarding,
  GameViewControllerStateStartGame,
  GameViewControllerStateGameInProgress,
  GameViewControllerStateResumeGame,
  GameViewControllerStateGameFinished
}GameViewControllerState;

@interface GameViewController : UIViewController

@property (nonatomic,assign) GameViewControllerState state;
+ (GameViewController *)gameViewControllerWithState:(GameViewControllerState)gameViewControllerState;

@end
