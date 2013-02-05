//
//  KLPatternShiftView.m
//  LoveLetter
//
//  Created by user on 2/4/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "KLPatternShiftView.h"

@interface KLPatternShiftView ()

@property (nonatomic) CGSize shift;
@property (nonatomic) CGColorRef pattern;

@end

@implementation KLPatternShiftView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image shift:(CGSize)shift {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.shift = shift;
        self.pattern = [UIColor colorWithPatternImage:image].CGColor;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // http://stackoverflow.com/questions/8515017/changing-the-phase-of-a-pattern-image
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetPatternPhase(context, self.shift);
    
    CGContextSetFillColorWithColor(context, self.pattern);
    CGContextFillRect(context, self.bounds);
    
    CGContextRestoreGState(context);
}

@end
