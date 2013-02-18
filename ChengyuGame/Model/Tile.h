//
//  Tile.h
//  ChengyuGame
//
//  Created by Nathan Chan on 2/7/13.
//  Copyright (c) 2013 Nathan Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tile : NSObject

@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic) int selectedOrder;

@end
