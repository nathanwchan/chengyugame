//
//  ChengyuGameViewController.m
//  ChengyuGame
//
//  Created by Nathan Chan on 2/7/13.
//  Copyright (c) 2013 Nathan Chan. All rights reserved.
//

#import "ChengyuGameViewController.h"
#import "CharacterTileView.h"
#import "CharacterTileCollectionViewCell.h"
#import "ChengyuGame.h"

@interface ChengyuGameViewController () <UICollectionViewDataSource>

@property (strong, nonatomic) IBOutletCollection(CharacterTileView) NSArray *characterTileViews;
@property (strong, nonatomic) ChengyuGame *game;
@property (weak, nonatomic) IBOutlet UICollectionView *characterTileCollectionView;
@property (nonatomic) int lastSelectedIndex;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@end

@implementation ChengyuGameViewController

- (NSInteger)characterTileCount
{
    return 16;
}

- (ChengyuGame *)game
{
    if (!_game) _game = [[ChengyuGame alloc] initWithTileCount:self.characterTileCount];
    
    return _game;
}

+ (NSArray *)allAdjacentIndexes
{
    return @[@[@1, @4, @5],
             @[@0, @2, @4, @5, @6],
             @[@1, @3, @5, @6, @7],
             @[@2, @6, @7],
             @[@0, @1, @5, @8, @9],
             @[@0, @1, @2, @4, @6, @8, @9, @10],
             @[@1, @2, @3, @5, @7, @9, @10, @11],
             @[@2, @3, @6, @10, @11],
             @[@4, @5, @9, @12, @13],
             @[@4, @5, @6, @8, @10, @12, @13, @14],
             @[@5, @6, @7, @9, @11, @13, @14, @15],
             @[@6, @7, @10, @14, @15],
             @[@8, @9, @13],
             @[@8, @9, @10, @12, @14],
             @[@9, @10, @11, @13, @15],
             @[@10, @11, @14]];
}

+ (BOOL)isThisIndexAdjacent:(int)index withOriginalIndex:(int)origIndex
{
    NSArray *adjacentIndexes = [self allAdjacentIndexes][origIndex];

    for (int i=0; i < adjacentIndexes.count; i++)
    {
        if ([adjacentIndexes[i] integerValue] == index)
        {
            return true;
        }
    }
    return false;
}

- (BOOL)updateIndexPathHistory:(int)indexPath
{
    if (self.lastSelectedIndex != -1 &&
        ![ChengyuGameViewController isThisIndexAdjacent:indexPath withOriginalIndex:self.lastSelectedIndex])
    {
        return false;
    }
    
    if (![self.game fourTilesSelected] &&
        self.lastSelectedIndex != indexPath &&
        [self.game tileAtIndex:indexPath].selected == false) // if panning to a non-selected tile
    {
        [self.game updateTileAtIndex:indexPath];
        self.lastSelectedIndex = indexPath;
        return true;
    }
    else if (self.lastSelectedIndex != indexPath &&
             [self.game tileAtIndex:indexPath].selected == true) // if panning to an already selected tile
    {
        if ([self.game tileAtIndex:indexPath].selectedOrder == [self.game tileAtIndex:self.lastSelectedIndex].selectedOrder - 1)
        {
            [self.game updateTileAtIndex:self.lastSelectedIndex]; // unselect tile just panned off
            self.lastSelectedIndex = indexPath;
            return true;
        }
        return false;
    }
    return false;
}

- (void)updateCell:(UICollectionViewCell *)cell withCharacterTile:(CharacterTile *)characterTile {
    if ([cell isKindOfClass:[CharacterTileCollectionViewCell class]]) {
        CharacterTileView *characterTileView = ((CharacterTileCollectionViewCell *)cell).characterTileView;
        characterTileView.character = characterTile.character;
        characterTileView.selected = characterTile.selected;
        characterTileView.selectedOrder = characterTile.selectedOrder;
    }
}

- (void)updateUI
{
    self.characterLabel.text = [self.game getSelectedCharacters];
    for (UICollectionViewCell *cell in [self.characterTileCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.characterTileCollectionView indexPathForCell:cell];
        CharacterTile *characterTile = [self.game tileAtIndex:indexPath.item];
        [self updateCell:cell withCharacterTile:characterTile];
    }
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender
{
    CGPoint panLocation = [sender locationInView:self.characterTileCollectionView];
    NSIndexPath *indexPath = [self.characterTileCollectionView indexPathForItemAtPoint:panLocation];
    if (indexPath) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            self.lastSelectedIndex = -1;
            
            // need a fix here to selected tile upon first tap (currently waits for pan)
        }
        else if (sender.state == UIGestureRecognizerStateChanged &&
            [self updateIndexPathHistory:indexPath.item]) {
            [self updateUI];
        }
        else if (sender.state == UIGestureRecognizerStateEnded ||
                 sender.state == UIGestureRecognizerStateCancelled)
        {
            if ([self.game fourTilesSelected])
            {
                // do something!!!
            }
            [self.game resetTiles];
            [self updateUI];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView // OPTIONAL
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.characterTileCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CharacterTile" forIndexPath:indexPath];
    CharacterTile *tile = [self.game tileAtIndex:indexPath.item];
    [self updateCell:cell withCharacterTile:tile];
    return cell;
}

@end
