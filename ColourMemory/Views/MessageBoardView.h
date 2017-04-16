//
//  MessageBoardView.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Message;

@interface MessageBoardView : UIView

@property (strong, nonatomic) Message *message;
@property (weak, nonatomic) IBOutlet UILabel *roundNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDetailsLabel;

+ (MessageBoardView *)messageBoardViewWithFrame:(CGRect)frame andMessage:(Message *)message;

@end
