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
     
        NSUInteger index = 0;
        for (CLSlat *slat in self.palette.slats) {
            CGFloat width = self.frame.size.width * slat.width;
            UIView *slatView = [[UIView alloc] initWithFrame:CGRectMake(width * index, 0, width, self.frame.size.height)];
            slatView.layer.backgroundColor = slat.color.CGColor;
            [self addSubview:slatView];
            index++;
        }
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
