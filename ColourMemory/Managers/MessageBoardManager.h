//
//  MessageBoardManager.h
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;
@class Round;

@interface MessageBoardManager : NSObject

@property (nonatomic,strong) Message *message;

- (void)showSameCardFlipMessage;
- (void)showFlippedCardsMatchedMessage;
- (void)showFlippedCardsNotMatchedMessage;
- (void)showGameWonMessage;
- (void)showResumeGameRoundFirstCardNotPickedMessage:(Round *)round;
- (void)showResumeGameRoundFirstCardPickedMessage:(Round *)round;
- (void)showNewGameMessage:(BOOL)onBoarding;
- (void)showNewRoundMessage;
- (void)showFirstCardFlippedMessage;

- (id)initWithMessage:(Message *)message;

@end
