//
//  ScoreView.h
//  ColourMemory
//
//  Created by Shekhar on 10/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Game;

@interface ScoreView : UIView

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfMatchesLabel;

+ (ScoreView *)scoreViewWithFrame:(CGRect)frame andGame:(Game *)game;

@end
