//
//  ChengyuGame.m
//  ChengyuGame
//
//  Created by Nathan Chan on 2/16/13.
//  Copyright (c) 2013 Nathan Chan. All rights reserved.
//

#import "ChengyuGame.h"

@interface ChengyuGame()
@property (strong, nonatomic) NSMutableArray *tiles;
@end

@implementation ChengyuGame

- (NSMutableArray *)tiles // LAZY INSTANTIATION!
{
    if (!_tiles) _tiles = [[NSMutableArray alloc] init];
    return _tiles;
}

- (id)initWithTileCount:(NSUInteger)tileCount
{
    self = [super init];
    
    if (self) {
        for (int i=0; i < tileCount; i++) {
            CharacterTile *tile = [ChengyuGame createRandomCharacterTile];
            if (!tile) {
                self = nil;
            } else {
                self.tiles[i] = tile;
            }
        }
    }
    
    return self;
}

- (CharacterTile *)tileAtIndex:(NSUInteger)index
{
    return (index < self.tiles.count) ? self.tiles[index] : nil;
}

- (void)resetTiles
{
    for (CharacterTile *tile in self.tiles)
    {
        tile.selected = false;
        tile.selectedOrder = 0;
    }
}

- (void)updateTileAtIndex:(NSUInteger)index
{
    CharacterTile *tile = [self tileAtIndex:index];
    
    tile.selected = !tile.selected;
    if (tile.selected) // if just was newly selected
    {
        tile.selectedOrder = [self getLastSelectedTile].selectedOrder + 1;
    }
    else {
        tile.selectedOrder = 0;
    }
}

- (CharacterTile *)getLastSelectedTile
{
    CharacterTile *lastSelectedTile = self.tiles[0];
    for (int i=1; i < self.tiles.count; i++)
    {
        CharacterTile *tempCharacterTile = (CharacterTile *)self.tiles[i];
        if (tempCharacterTile.selectedOrder > lastSelectedTile.selectedOrder)
        {
            lastSelectedTile = self.tiles[i];
        }
    }
    return lastSelectedTile;
}

- (int)getLastSelectedTileIndex
{
    CharacterTile *lastSelectedTile = self.tiles[0];
    int lastSelectedTileIndex = -1;
    for (int i=1; i < self.tiles.count; i++)
    {
        CharacterTile *tempCharacterTile = (CharacterTile *)self.tiles[i];
        if (tempCharacterTile.selectedOrder > lastSelectedTile.selectedOrder)
        {
            lastSelectedTile = self.tiles[i];
            lastSelectedTileIndex = i;
        }
    }
    return lastSelectedTileIndex;
}

- (NSString *)getSelectedCharacters
{
    NSString *returnString = @"****";
    for (int i=0; i < self.tiles.count; i++)
    {
        CharacterTile *tempCharacterTile = (CharacterTile *)self.tiles[i];
        if (tempCharacterTile.selectedOrder > 0)
        {
            returnString = [returnString stringByReplacingCharactersInRange:NSMakeRange(tempCharacterTile.selectedOrder - 1, 1) withString:tempCharacterTile.character];
        }
    }
    return returnString;
}

- (BOOL)fourTilesSelected
{
    int count = 0;
    for (int i=0; i < self.tiles.count; i++)
    {
        CharacterTile *tempCharacterTile = (CharacterTile *)self.tiles[i];
        if (tempCharacterTile.selected)
        {
            count++;
        }
    }
    return (count == 4) ? true : false;
}

+ (CharacterTile *)createRandomCharacterTile
{
    CharacterTile *newCharacterTile = [[CharacterTile alloc] init];
    
    newCharacterTile.character = [ChengyuGame getRandomCharacter];
    newCharacterTile.selected = false;
    newCharacterTile.selectedOrder = 0;
    
    return newCharacterTile;
}

+ (NSString *)getRandomCharacter
{
    NSArray *randomStrings = @[@"我", @"爱", @"你", @"名", @"图", @"字"];
    return randomStrings[arc4random() % randomStrings.count];
}

@end
