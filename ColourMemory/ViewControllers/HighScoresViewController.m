//
//  PlayerRankingViewController.m
//  ColourMemory
//
//  Created by Shekhar on 10/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "HighScoresViewController.h"
#import "UIManager.h"
#import "GameManager.h"
#import "HighScoresTableViewCell.h"
#import "UIView+RoundEdgeAndBorder.h"
#import "TableViewWithPlaceholder.h"

@interface HighScoresViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) GameManager *gameManager;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet TableViewWithPlaceholder *rankingTableView;
@property (nonatomic,strong) NSMutableArray *games;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HighScoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self.headerView maskRoundCorners:UIRectCornerAllCorners radius:5];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
  [self setup];
}

- (void)setup
{
  self.gameManager = [GameManager sharedInstance];
  self.games = (NSMutableArray *)self.gameManager.gamesSortedByRanking;
  if (!self.games) {
    self.games = [NSMutableArray array];
  }
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(),^ {
    [self showSummary];
  });
  
  PlaceholderData *placeHolderData = [[PlaceholderData alloc] init];
  placeHolderData.titleText = @"No saved games found.";
  placeHolderData.imageName = @"logo";
  placeHolderData.buttonText = @"BACK TO THE GAME";
  PlaceHolderView *placeholderView = [[PlaceHolderView alloc] initWithFrame:self.rankingTableView.frame placeholderData:placeHolderData];
  self.rankingTableView.placeholderView = placeholderView;
  typeof(self) __weak wSelf = self;
  self.rankingTableView.placeholderView.actionButtonBlock = ^{
    typeof(self) __strong sSelf = wSelf;
    if (!sSelf) return;
    [sSelf closeButtonTapped:nil];
  };
}

- (void)dealloc
{
  self.rankingTableView.delegate = nil;
  self.rankingTableView.dataSource = nil;
}

- (void)showSummary
{
  if (!self.games.count) {
    self.headerView.hidden = YES;
    self.titleLabel.hidden = YES;
  }
  if (self.rankingTableView) {
    [self.rankingTableView setDelegate:self];
    [self.rankingTableView setDataSource:self];
    [self.rankingTableView beginUpdates];
    NSMutableArray * cardIndexPaths = [NSMutableArray array];
    for (int i = 0 ; i < self.games.count; i ++) {
      [cardIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.rankingTableView insertRowsAtIndexPaths:cardIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.rankingTableView endUpdates];
  }
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  static NSString *cellIdentifier = @"HighScoresTableViewCell";
  HighScoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  Game *game = [self.games objectAtIndex:indexPath.row];
  game.rank = indexPath.row + 1;
  if (!cell) cell = [HighScoresTableViewCell loadHighScoresTableViewCell];
  [cell setGameData:game];
  return cell;
  
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  return;
}

- (IBAction)closeButtonTapped:(id)sender {
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  CATransition* transition = [CATransition animation];
  transition.duration = 0.2;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionFade;
  [self.navigationController.view.layer addAnimation:transition forKey:nil];
  [[self navigationController] popViewControllerAnimated:NO];
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
