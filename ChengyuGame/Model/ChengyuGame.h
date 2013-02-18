//
//  ChengyuGame.h
//  ChengyuGame
//
//  Created by Nathan Chan on 2/16/13.
//  Copyright (c) 2013 Nathan Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CharacterTile.h"

@interface ChengyuGame : NSObject

- (id)initWithTileCount:(NSUInteger)tileCount;

- (void)updateTileAtIndex:(NSUInteger)index;

- (CharacterTile *)tileAtIndex:(NSUInteger)index;

- (CharacterTile *)getLastSelectedTile;
- (int)getLastSelectedTileIndex;

- (NSString *)getSelectedCharacters;

- (BOOL)fourTilesSelected;

- (void)resetTiles;

@end
