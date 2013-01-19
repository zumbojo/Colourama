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
     
        /*
        NSUInteger index = 0;
        for (CLSlat *slat in self.palette.slats) {
            CGFloat width = self.frame.size.width * slat.width;
            UIView *slatView = [[UIView alloc] initWithFrame:CGRectMake(width * index, 0, width, self.frame.size.height)];
            slatView.layer.backgroundColor = slat.color.CGColor;
            [self addSubview:slatView];
            index++;
        }
         */
        
        CGFloat width = self.frame.size.width * 0.33;
        UIView *one = [[UIView alloc] init];
        one.layer.backgroundColor = ((CLSlat *)self.palette.slats[0]).color.CGColor;
        [one setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:one];
        
        UIView *two = [[UIView alloc] init];
        two.layer.backgroundColor = ((CLSlat *)self.palette.slats[1]).color.CGColor;
        [two setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:two];

//        UIView *three = [[UIView alloc] initWithFrame:CGRectMake(width * 2, 0, width, self.frame.size.height)];
//        three.layer.backgroundColor = ((CLSlat *)self.palette.slats[2]).color.CGColor;
//        [self addSubview:three];
        
        // visual format syntax: http://developer.apple.com/library/mac/#documentation/UserExperience/Conceptual/AutolayoutPG/Articles/formatLanguage.html#//apple_ref/doc/uid/TP40010853-CH3-SW1
        
        NSDictionary *views = NSDictionaryOfVariableBindings(one, two);
        
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[one][two(==one)]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
        
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[one]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];

        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[two]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
        
        
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
