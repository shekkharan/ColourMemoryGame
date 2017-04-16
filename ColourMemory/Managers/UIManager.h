//
//  UIManager.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIManager : NSObject

+ (UIManager *)sharedInstance;
- (void)launchApplication;
- (void)launchGame;
- (void)launchGameFromTutorial;
+ (UIViewController *)gameViewController;
+ (UIViewController *)saveGameViewController;
+ (UIViewController *)highScoresViewController;
@end
