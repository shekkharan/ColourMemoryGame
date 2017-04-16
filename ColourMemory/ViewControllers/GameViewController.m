//
//  GameViewController.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "GameViewController.h"
#import "UIManager.h"
#import "MessageBoardView.h"
#import "GameBoardView.h"
#import "ScoreView.h"
#import "APRoundedButton.h"
#import "SaveGameViewController.h"
#import "AnimationHelper.h"
#import "Game.h"
#import "Message.h"
#import "HighScoresViewController.h"

#import "UIView+RoundEdgeAndBorder.h"

#define NSLOGFRAME(view) NSLog(@"FRAME -- %f,%f,%f,%f",view.frame.origin.x,view.frame.origin.y,view.frame.size.width,view.frame.size.height);
#define NSLOGBOUNDS(view) NSLog(@"BOUNDS -- %f,%f,%f,%f",view.bounds.origin.x,view.bounds.origin.y,view.bounds.size.width,view.bounds.size.height);

double delayBetweenRoundsInSeconds = 0.8;

typedef void (^EndCurrentRoundBlock) ();
typedef void (^ShowSaveGameModalBlock) ();

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *highScoresButton;
@property (strong, nonatomic) Message *message;
@property (weak, nonatomic) IBOutlet MessageBoardView *messageBoardView;
@property (weak, nonatomic) IBOutlet APRoundedButton *quitGameButton;
@property (weak, nonatomic) IBOutlet GameBoardView *gameBoardView;
@property (weak, nonatomic) IBOutlet ScoreView *scoreView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic,strong) GameManager *gameManager;

@end

@implementation GameViewController
{
  BOOL gameOverWasShown;
  BOOL firstCardWasFlipped;
  BOOL highScoresWasOpened;
  double delayToShowSaveGameInSeconds;;
}

+ (GameViewController *)gameViewControllerWithState:(GameViewControllerState)gameViewControllerState
{
  GameViewController *gameViewController = (GameViewController *)[UIManager gameViewController];
  gameViewController.state = gameViewControllerState;
  gameViewController.gameManager = [GameManager sharedInstance];
  gameViewController.message = [GameManager sharedInstance].messageBoardManager.message;
  return gameViewController;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.highScoresButton maskRoundCorners:UIRectCornerAllCorners radius:5];
    if (self.state != GameViewControllerStateGameInProgress) {
      [self setup];
    }
}

#pragma mark - Setup

- (void)setup
{
  switch (self.state) {
    case GameViewControllerStateJustAfterOnboarding:
    {
      Game *newGame = [self.gameManager startNewGamePostOnBoarding];
      
      [self renderInterfaceWithGame:newGame];
      
      self.state = GameViewControllerStateGameInProgress;
      
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
      dispatch_after(popTime, dispatch_get_main_queue(),^{
        [self.gameBoardView showResetAnimation];
      });
    }
      break;
    case GameViewControllerStateStartGame:
    {
      Game *newGame = [self.gameManager startNewGame];
      [self renderInterfaceWithGame:newGame];
      
      self.state = GameViewControllerStateGameInProgress;
      
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
      dispatch_after(popTime, dispatch_get_main_queue(),^{
        [self.gameBoardView showResetAnimation];
      });
    }
      break;
      
    case GameViewControllerStateResumeGame:
    {
      Game *game;
      if (self.gameManager.activeGame && (self.gameManager.activeGame.numberOfMatches == kNumberOfColours)) {
        [self performGameOver];
        return;
      } else if (self.gameManager.activeGame) {
        game = self.gameManager.activeGame;
        [self.gameManager resumeGame];
      } else {
        game = [self.gameManager startNewGame];
      }
      
      [self renderInterfaceWithGame:game];
      self.state = GameViewControllerStateGameInProgress;
      
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
      dispatch_after(popTime, dispatch_get_main_queue(),^{
        [self.gameBoardView showResetAnimation];
      });
      
    }
      break;
      
    case GameViewControllerStateGameInProgress:
    {
      Game *game;
      if (self.gameManager.activeGame && (self.gameManager.activeGame.numberOfMatches == 8)) {
        [self performGameOver];
        return;
      } else if (self.gameManager.activeGame) {
        game = self.gameManager.activeGame;
        [self.gameManager resumeGame];
      } else {
        game = [self.gameManager startNewGame];
      }
    
      [self renderInterfaceWithGame:game];
      self.state = GameViewControllerStateGameInProgress;
      
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
      dispatch_after(popTime, dispatch_get_main_queue(),^{
        [self.gameBoardView showResetAnimation];
      });

    }
      break;
    case GameViewControllerStateGameFinished:
    {
      if (self.gameManager.activeGame) {
        [self.gameManager quitActiveGame];
      }
      CGRect gameBoardViewFrame = self.gameBoardView.frame;
      CGRect scoreViewFrame = self.scoreView.frame;
      [self.gameBoardView removeFromSuperview];
      [self.scoreView removeFromSuperview];
      self.gameBoardView = nil;
      self.scoreView = nil;
      
      Game *newGame = [self.gameManager startNewGame];
      self.gameBoardView = [GameBoardView gameBoardViewWithFrame:gameBoardViewFrame andGame:newGame];
      self.gameBoardView.cardSelectBlock = [self cardSelectedBlock];
      self.gameBoardView.unFlipCardsCompletedBlock = [self unFlipCardsCompletedBlock];
      [self.view addSubview:self.gameBoardView];
      
      self.messageBoardView = [MessageBoardView messageBoardViewWithFrame:self.messageBoardView.frame andMessage:self.message];
      [self.view addSubview:self.messageBoardView];
      
      self.scoreView = [ScoreView scoreViewWithFrame:scoreViewFrame andGame:newGame];
      [self.headerView addSubview:self.scoreView];
      
      self.state = GameViewControllerStateGameInProgress;
      
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
      dispatch_after(popTime, dispatch_get_main_queue(),^{
        [self.gameBoardView showResetAnimation];
      });
    }
      break;
  }
  self.scoreView.layer.shadowColor = [UIColor grayColor].CGColor;
  self.scoreView.layer.shadowOffset = CGSizeMake(2, 2);
  self.scoreView.layer.shadowOpacity = 1;
  self.scoreView.layer.shadowRadius = 1.0;
}

- (void)renderInterfaceWithGame:(Game *)game
{
  self.gameBoardView = [GameBoardView gameBoardViewWithFrame:self.gameBoardView.frame andGame:game];
  self.gameBoardView.cardSelectBlock = [self cardSelectedBlock];
  self.gameBoardView.unFlipCardsCompletedBlock = [self unFlipCardsCompletedBlock];
  [self.view addSubview:self.gameBoardView];
  
  
  self.messageBoardView = [MessageBoardView messageBoardViewWithFrame:self.messageBoardView.frame andMessage:self.message];
  [self.view addSubview:self.messageBoardView];
  
  
  self.scoreView = [ScoreView scoreViewWithFrame:self.scoreView.frame andGame:game];
  [self.headerView addSubview:self.scoreView];

}

#pragma mark - GameBoard Blocks

- (CardSelectBlock)cardSelectedBlock
{
  typeof(self) __weak wSelf = self;
  CardSelectBlock cardSelectedBlock = ^(Card *card, BOOL isSameCard) {
    typeof(self) __strong sSelf = wSelf;
    if (!sSelf) return;
    if (card) {
      [sSelf.gameManager flipCard:card withBlock:[sSelf cardFlipResultBlock]];
    }
  };
  return cardSelectedBlock;
}

- (UnFlipCardsCompletedBlock)unFlipCardsCompletedBlock
{
  typeof(self) __weak wSelf = self;
  UnFlipCardsCompletedBlock unFlipCardsCompletedBlock = ^() {
    typeof(self) __strong sSelf = wSelf;
    if (!sSelf) return;
    if (self.gameManager.activeGame.numberOfMatches == kNumberOfColours) {
      [self performGameOver];
    }
    else {
      if (!firstCardWasFlipped) {
        firstCardWasFlipped = YES;
        [sSelf.gameManager startNewRound];
      } else {
        firstCardWasFlipped = NO;
      }
    }
  };
  return unFlipCardsCompletedBlock;
}

#pragma mark - GameManager Blocks

- (FlipCardResultBlock)cardFlipResultBlock
{
  typeof(self) __weak wSelf = self;
  FlipCardResultBlock cardFlipResultBlock = ^(FlipCardResultType result, Round *currentRound) {
    typeof(self) __strong sSelf = wSelf;
    if (!sSelf) return;
    switch (result) {
      case FlipCardResultNoMatch:
      {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayBetweenRoundsInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(),[sSelf endCurrentRoundBlock]);
      }
        break;
      case FlipCardResultHasMatched:
      {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayBetweenRoundsInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(),[sSelf endCurrentRoundBlock]);
      }
        break;
      case FlipCardResultGameWon:
      {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayBetweenRoundsInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(),[sSelf endCurrentRoundBlock]);
      }
        break;
    }
  };
  return cardFlipResultBlock;
}

#pragma mark - Delay Blocks

- (EndCurrentRoundBlock)endCurrentRoundBlock
{
  typeof(self) __weak wSelf = self;
  EndCurrentRoundBlock endCurrentRoundBlock = ^{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    typeof(self) __strong sSelf = wSelf;
    if (!sSelf) return;
    [sSelf.gameManager endCurrentRound];
  };
  return endCurrentRoundBlock;
}

- (ShowSaveGameModalBlock)showSaveGameModalBlock
{
  typeof(self) __weak wSelf = self;
  ShowSaveGameModalBlock showSaveGameModalBlock = ^{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    typeof(self) __strong sSelf = wSelf;
    if (!sSelf) return;
    self.state = GameViewControllerStateGameFinished;
    SaveGameViewController *saveGameViewController = (SaveGameViewController *)[UIManager saveGameViewController];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:saveGameViewController];
    saveGameViewController.navigationController.navigationBarHidden = YES;
    [sSelf presentViewController:navigationController animated:YES completion:nil];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

  };
  return showSaveGameModalBlock;
}

#pragma mark - Action methods

- (IBAction)highScoresButtonTapped:(id)sender {
  HighScoresViewController *highScoresViewController = (HighScoresViewController *)[UIManager highScoresViewController];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:highScoresViewController];
  highScoresViewController.navigationController.navigationBarHidden = YES;
  highScoresWasOpened = YES;
  [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)performGameOver
{
  if (!gameOverWasShown) {
    gameOverWasShown = YES;
    [self.gameBoardView showGameOver];
  } else {
    gameOverWasShown = NO;
  }
  if (self.state == GameViewControllerStateResumeGame) {
    delayToShowSaveGameInSeconds = 0;
  } else if (self.state == GameViewControllerStateResumeGame) {
    delayToShowSaveGameInSeconds = 2;
  } else {
    delayToShowSaveGameInSeconds = 1;
  }
  
  [self showSaveGameModal];
}

- (void)showSaveGameModal
{
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayToShowSaveGameInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(),[self showSaveGameModalBlock]);
}

-(void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
