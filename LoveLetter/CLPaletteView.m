//
//  CLPaletteView.m
//  LoveLetter
//
//  Created by user on 1/18/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLPaletteView.h"
#import <QuartzCore/QuartzCore.h>
#import "CLPalette.h"
#import "CLSlat.h"

@implementation CLPaletteView

- (id)initWithFrame:(CGRect)frame palette:(CLPalette *)palette
{
    self = [super initWithFrame:frame];
    if (self) {
        _palette = palette;
        
        self.layer.backgroundColor = ((CLSlat *)self.palette.slats[0]).color.CGColor;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
