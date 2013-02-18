//
//  CharacterTileView.m
//  ChengyuGame
//
//  Created by Nathan Chan on 2/8/13.
//  Copyright (c) 2013 Nathan Chan. All rights reserved.
//

#import "CharacterTileView.h"

@implementation CharacterTileView

#define CORNER_RADIUS 12.0

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    if (self.selected) {
        [[UIColor blueColor] setFill];
    }
    else {
        [[UIColor whiteColor] setFill];
    }
        
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *characterFont = [UIFont systemFontOfSize:self.bounds.size.width * 0.6];
    
    NSAttributedString *characterText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.character]
                                                                        attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : characterFont }];

    CGFloat fontHeight = characterFont.pointSize;
    CGFloat yOffset = (self.bounds.size.height - fontHeight) / 3.0;
    CGRect textRect = CGRectInset(self.bounds, 0, yOffset);
    [characterText drawInRect:textRect];
}

- (void)setCharacter:(NSString *)character
{
    _character = character;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)setSelectedOrder:(int)selectedOrder
{
    _selectedOrder = selectedOrder;
    [self setNeedsDisplay];
}

- (void)setup
{
    // initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
