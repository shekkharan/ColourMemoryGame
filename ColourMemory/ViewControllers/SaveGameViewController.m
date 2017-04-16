//
//  SaveGameViewController.m
//  ColourMemory
//
//  Created by Shekhar on 10/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "SaveGameViewController.h"
#import "APRoundedButton.h"
#import "GameSummaryView.h"
#import "GameManager.h"
#import "IQKeyboardManager.h"
#import "UIView+RoundEdgeAndBorder.h"
#import "Game.h"
#import "Player.h"
#import "NSArray+Predicate.h"
#import "AnimationHelper.h"
#import "HighScoresViewController.h"
#import "UIManager.h"
#import "UIFont+AppFonts.h"
#import "UIColor+AppColors.h"

@interface SaveGameViewController () <UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) GameManager *gameManager;
@property (weak, nonatomic) IBOutlet UITextField *playerNameTextField;
@property (weak, nonatomic) IBOutlet APRoundedButton *saveGameButton;
@property (weak, nonatomic) IBOutlet GameSummaryView *gameSummaryView;
@property (weak, nonatomic) IBOutlet UIView *savePlayerNameContainerView;
@property (weak, nonatomic) IBOutlet UITableView *recentNamesTableView;
@property (nonatomic,strong) NSMutableArray *recentPlayers;

@end

@implementation SaveGameViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self hideRecentPlayersTable];
  [self.recentNamesTableView maskRoundCorners:UIRectCornerAllCorners radius:5];
  [self.savePlayerNameContainerView maskRoundCorners:UIRectCornerAllCorners radius:8];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
  [self setup];
}

-(void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

#pragma mark - Setup

- (void)setup
{
  self.gameManager = [GameManager sharedInstance];
  self.gameSummaryView = [GameSummaryView gameSummaryViewWithFrame:self.gameSummaryView.frame andGame:self.gameManager.activeGame];
  
  [self.view addSubview:self.gameSummaryView];
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(),^ {
    [self.gameSummaryView showSummary];
  });
  
  self.recentPlayers = (NSMutableArray *)self.gameManager.playerslist;
  if (!self.recentPlayers) {
    self.recentPlayers = [NSMutableArray array];
  }
  
  self.recentNamesTableView.dataSource = self;
  self.recentNamesTableView.delegate = self;
  self.playerNameTextField.delegate = self;
  
  [self.view bringSubviewToFront:self.recentNamesTableView];
  self.recentNamesTableView.backgroundColor = [UIColor whiteColor];
  
  self.playerNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [[IQKeyboardManager sharedManager] setEnable:YES];
  [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
  [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
  
//  dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
//  dispatch_after(waitTime, dispatch_get_main_queue(),^{
//    [self.playerNameTextField becomeFirstResponder];
//  });
}

#pragma mark - UITextField delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (!textField.text.length) {
    return NO;
  }
  [self saveGame];
  return YES;
}

- (BOOL) textFieldShouldClear:(UITextField *)textField {
  self.recentPlayers = (NSMutableArray *)self.gameManager.playerslist;
  [self.recentNamesTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.playerNameTextField becomeFirstResponder];
  return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
  if (searchText.length > 0) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@",searchText];
    self.recentPlayers = (NSMutableArray *)[self.gameManager.playerslist getAllItemsMatchingPredicate:predicate];
    if (!self.recentPlayers.count) {
      [self hideRecentPlayersTable];
    } else {
      if (self.recentNamesTableView.hidden) {
        [self showRecentPlayersTable];
      }
    }
  } else {
    self.recentPlayers = (NSMutableArray *)self.gameManager.playerslist;
    if (!self.recentPlayers.count) {
      [self hideRecentPlayersTable];
    } else {
      if (self.recentNamesTableView.hidden) {
        [self showRecentPlayersTable];
      }
    }
  }
  [self.recentNamesTableView reloadData];
  return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
  if (self.recentPlayers.count) {
    [self.recentNamesTableView reloadData];
    [self showRecentPlayersTable];
  }
  return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  if (!self.recentNamesTableView.hidden) {
    [self hideRecentPlayersTable];
  }
  return YES;
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.recentPlayers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"cellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  Player *player = [self.recentPlayers objectAtIndex:indexPath.row];
  cell.textLabel.text = player.name;
  cell.textLabel.font = [UIFont mediumAppFontOfSize:16];
  return cell;
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  Player *player = [self.recentPlayers objectAtIndex:indexPath.row];
  self.playerNameTextField.text = player.name;
  [self.playerNameTextField resignFirstResponder];
  [self hideRecentPlayersTable];
  return;
}

#pragma mark - scrollView delegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
  [self.recentNamesTableView endEditing:YES];
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  if ([touch.view isDescendantOfView:self.recentNamesTableView]) {
    return NO;
  }
  return YES;
}

#pragma mark - action methods

- (IBAction)clickedOutsideTableview:(id)sender {
  if (!self.recentNamesTableView.hidden) {
    [self hideRecentPlayersTable];
    [self.recentNamesTableView endEditing:YES];
  }
}

- (void)saveGame
{
  [self.playerNameTextField resignFirstResponder];
  Player *player = [[Player alloc] initWithName:self.playerNameTextField.text];
  self.gameManager.activeGame.player = player;
  if (self.gameManager.activeGame.player.name.length) {
    [self.gameManager saveFinishedGame:^(BOOL success) {
      if (success) {
        [self showHighScores];
      } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"Game not saved. Please re-try." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alertView.tag = 4;
        [alertView show];
      }
    }];
  } else {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Player name required" message:@"Enter your name and try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alertView.tag = 2;
    [alertView show];
  }
}

- (void)showHighScores
{
  HighScoresViewController *highScoresViewController = (HighScoresViewController *)[UIManager highScoresViewController];
  highScoresViewController.navigationController.navigationBarHidden = YES;
  [self.navigationController pushViewController:highScoresViewController animated:YES];
}

- (void)showRecentPlayersTable
{
  self.recentNamesTableView.hidden = NO;
  [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
  [AnimationHelper showViewWithAnimation:self.recentNamesTableView withDuration:0.2];
}

- (void)hideRecentPlayersTable
{
  self.recentNamesTableView.hidden = YES;
  [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
  [AnimationHelper showAnimationOnView:self.recentNamesTableView withDuration:0.4];
}

- (IBAction)saveGameButtonTapped:(id)sender {
  if (!self.playerNameTextField.text.length) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Player name required" message:@"Please enter your name and try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alertView.tag = 2;
    [alertView show];
  } else {
    [self saveGame];
  }
}

- (IBAction)closeButtonTapped:(id)sender {
  if (!self.playerNameTextField.text.length) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"You played so well. Are you sure to leave without saving the game?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertView.tag = 1;
    [alertView show];
  }
  else [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  switch (alertView.tag) {
    case 1:
    {
      if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
      }
    }
      break;
    case 2:
    {
      
    }
      break;
    case 3:
    {
      if (buttonIndex == 1) {
        [self showHighScores];
      }
    }
      break;
    case 4:
    {
      
    }
      break;
  }
  
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if([segue.identifier isEqualToString:@"ShowHighScoresFromSaveGame"]) {
     [self.view endEditing:YES];
  }
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
