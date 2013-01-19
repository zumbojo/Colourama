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

@implementation CLPaletteView

- (id)initWithFrame:(CGRect)frame palette:(CLPalette *)palette
{
    self = [super initWithFrame:frame];
    if (self) {
        _palette = palette;
        
        NSUInteger randomIndex = arc4random_uniform(self.palette.slats.count);
        CLSlat *slat = ((CLSlat *)self.palette.slats[randomIndex]);
        self.layer.backgroundColor = slat.color.CGColor;
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
