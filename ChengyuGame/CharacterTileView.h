//
//  CharacterTileView.h
//  ChengyuGame
//
//  Created by Nathan Chan on 2/8/13.
//  Copyright (c) 2013 Nathan Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterTileView : UIView

@property (strong, nonatomic) NSString *character;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic) int selectedOrder;

@end
