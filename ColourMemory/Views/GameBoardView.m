//
//  BoardView.m
//  ColourMemory
//
//  Created by Shekhar on 9/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "GameBoardView.h"
#import "GameBoardCollectionViewCell.h"
#import "Game.h"
#import "Card.h"

#define NSLOGFRAME(view) NSLog(@"FRAME -- %f,%f,%f,%f",view.frame.origin.x,view.frame.origin.y,view.frame.size.width,view.frame.size.height);
#define NSLOGBOUNDS(view) NSLog(@"BOUNDS -- %f,%f,%f,%f",view.bounds.origin.x,view.bounds.origin.y,view.bounds.size.width,view.bounds.size.height);

static const NSInteger kGridCount = 4;
static const CGFloat kTotalHeightofViewsOnTop = 170;

@interface GameBoardView ()
{
  BOOL flippingInProgress;
}

@property(nonatomic,strong) NSMutableArray *cardGrid;

@end

@implementation GameBoardView 

+ (GameBoardView *)gameBoardViewWithFrame:(CGRect)frame andGame:(Game *)game
{
  GameBoardView *gameBoardView = [[[NSBundle mainBundle] loadNibNamed:@"GameBoardView" owner:self options:nil] objectAtIndex:0];
  gameBoardView.frame = frame;
  [gameBoardView setup];
  gameBoardView.game = game;
  if (game.cards) {
    if (game.currentRound.number >= 1) {
      [gameBoardView resumeGame];
    }
    else [gameBoardView resetBoardWithNewGame:game];
  }
  return gameBoardView;
}

#pragma mark - setup

- (void)setup
{
  UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
  flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
  flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width)/4, ([UIScreen mainScreen].bounds.size.height - kTotalHeightofViewsOnTop)/4);
  flowLayout.minimumInteritemSpacing = 0;
  flowLayout.minimumLineSpacing = 0;
  [self.gameBoardCollectionView registerNib:[UINib nibWithNibName:@"GameBoardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellIdentifier"];
  [self.gameBoardCollectionView setDelegate:self];
  [self.gameBoardCollectionView setDataSource:self];
  self.gameBoardCollectionView.collectionViewLayout = flowLayout;
}

#pragma mark - action methods

- (void)resetBoardWithNewGame:(Game *)game
{
  self.cardGrid = [NSMutableArray array];
  for (int i = 0; i < kGridCount; i++) {
    
    NSMutableArray *rowArray = [NSMutableArray array];
    for(int j = i*kGridCount; j < (i+1)*kGridCount; j++) {
      Card *card = [self.game.cards objectAtIndex:j];
      card.row = i;
      card.column = j;
      card.type = CardTypeUnflipped;
      card.gameEnded = NO;
      card.number = 0;
      card.animateAtReset = NO;
      [rowArray addObject:card];
    }
    [self.cardGrid addObject:rowArray];
  }
  
  [self.gameBoardCollectionView reloadData];
}

- (void)resumeGame
{
  self.cardGrid = [NSMutableArray array];
  for (int i = 0; i < kGridCount; i++) {
    
    NSMutableArray *rowArray = [NSMutableArray array];
    for(int j = i*kGridCount; j < (i+1)*kGridCount; j++) {
      Card *card = [self.game.cards objectAtIndex:j];
      card.row = i;
      card.column = j;
      card.animateAtReset = NO;
      [rowArray addObject:card];
    }
    [self.cardGrid addObject:rowArray];
  }
  [self.gameBoardCollectionView reloadData];
}

- (void)showResetAnimation
{
  int cardNumber = 0;
  for (Card *card in self.game.cards) {
    card.animateAtReset = YES;
    cardNumber ++;
  }
}

- (void)showGameOver
{
  int cardNumber = 0;
  for (Card *card in self.game.cards) {
    card.number = cardNumber;
    card.gameEnded = YES;
    cardNumber ++;
  }
}

#pragma mark - UICollectionViewDataSource & Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return kGridCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return kGridCount;
}

- (GameBoardCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  GameBoardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

  Card *card = [[self.cardGrid objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  if (!cell) cell = [GameBoardCollectionViewCell loadGameBoardCollectionViewCell];
  [cell setCardData:card];
  cell.cardView.flipDidCompleteBlock = [self flipDidCompleteBlockWithCard:card];
  cell.cardView.unflipDidCompleteBlock = [self unflipDidCompleteBlockWithCard:card];
  [cell.cardView addObserver:self forKeyPath:@"flippingInProgress" options:0 context:nil];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  if (flippingInProgress) {
    return;
  }
  Card *card = [[self.cardGrid objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  switch (card.type) {
    case CardTypeInvisible:
    {
      return;
    }
      break;
    case CardTypeFlipped:
    {
      if(self.cardSelectBlock) {
        self.cardSelectBlock(card,YES);
      }
    }
      break;
    case CardTypeUnflipped:
    {
      card.type = CardTypeFlipped;
    }
      break;
  }
}

#pragma mark - Blocks

- (FlipDidCompleteBlock)flipDidCompleteBlockWithCard:(Card *)card
{
  typeof(self) __weak wSelf = self;
  FlipDidCompleteBlock flipDidCompleteBlock = ^{
    typeof(self) __strong sSelf = wSelf;
    if (!sSelf) return;
    if(sSelf.cardSelectBlock) {
      sSelf.cardSelectBlock(card,NO);
    }
  };
  return flipDidCompleteBlock;
}

- (UnflipDidCompleteBlock)unflipDidCompleteBlockWithCard:(Card *)card
{
  typeof(self) __weak wSelf = self;
  UnflipDidCompleteBlock unflipDidCompleteBlock = ^{
    typeof(self) __strong sSelf = wSelf;
    if (!sSelf) return;
    if (self.unFlipCardsCompletedBlock) {
      self.unFlipCardsCompletedBlock();
    }
  };
  return unflipDidCompleteBlock;
}

#pragma mark - KVO methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"flippingInProgress"])
  {
    CardView *cardView = (CardView *)object;
    if (cardView.flippingInProgress) {
      flippingInProgress = YES;
    } else {
      flippingInProgress = NO;
    }
  }
}

- (void)dealloc
{
  self.gameBoardCollectionView.delegate = nil;
  self.gameBoardCollectionView.dataSource = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
