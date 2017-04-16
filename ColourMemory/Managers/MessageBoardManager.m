//
//  MessageBoardManager.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "MessageBoardManager.h"
#import "Message.h"
#import "Game.h"

@implementation MessageBoardManager

- (id)initWithMessage:(Message *)message
{
  self = [super init];
  if (self) {
    _message = message;
  }
  return self;
}

- (void)showSameCardFlipMessage
{
  self.message.title = @"Sorry, cant do that!";
  self.message.details = @"Please flip another card";
}

- (void)showFlippedCardsMatchedMessage
{
  self.message.title = @"Awesome!";
  self.message.details = @"Right Match! You've earned +2 pts";
}

- (void)showFlippedCardsNotMatchedMessage
{
  self.message.title = @"Oh no!";
  self.message.details = @"You lose a point. Make it up at the next try!";
}

- (void)showGameWonMessage
{
  self.message.title = @"Woohoo!";
  self.message.details = @"Congratulations! You've won!";
}

- (void)showResumeGameRoundFirstCardNotPickedMessage:(Round *)round
{
  self.message.title = @"Resuming Game";
  self.message.details = @"To resume, flip a card";
  self.message.roundNumber = round.number;
}

- (void)showResumeGameRoundFirstCardPickedMessage:(Round *)round
{
  self.message.title = @"Resuming Game";
  self.message.details = @"To complete the round, flip the second card";
  self.message.roundNumber = round.number;
}

- (void)showNewGameMessage:(BOOL)onBoarding
{
  if (onBoarding) {
    self.message.title = @"Ready to go?";
  } else {
    self.message.title = @"New Game";
  }
  self.message.details = @"Start the game by flipping a card";
  self.message.roundNumber = 1;
}

- (void)showNewRoundMessage
{
  self.message.title = @"Go on!";
  self.message.details = @"Next Round, flip a card";
  self.message.roundNumber = self.message.roundNumber + 1;
}

- (void)showFirstCardFlippedMessage
{
  self.message.title = @"Flip the next one";
  self.message.details = @"Fingers crossed!";
}

@end
