//
//  KLPatternShiftView.m
//  LoveLetter
//
//  Created by user on 2/4/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "KLPatternShiftView.h"

@interface KLPatternShiftView ()

@property (nonatomic) UIImage *image;
@property (nonatomic) CGColorRef pattern;

@end

@implementation KLPatternShiftView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = image;
        self.pattern = [UIColor colorWithPatternImage:image].CGColor;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Determine best shift (we don't want the pattern to start at (0,0) and get cut off predictably at the right and bottom edges).
    // (Though because we don't control the patterns, edges will surely look weird on some patterns.  Nothing short of fancy image analysis can fix this, probably.)
    CGFloat scale = [[UIScreen mainScreen] scale]; // http://stackoverflow.com/questions/4779221/in-iphone-app-how-to-detect-the-screen-resolution-of-the-device
    CGFloat xShift = fmod(self.bounds.size.width * scale, CGImageGetWidth(self.image.CGImage)) / 2;
    CGFloat yShift = fmod(self.bounds.size.height * scale, CGImageGetHeight(self.image.CGImage)) / 2;
    
    // http://stackoverflow.com/questions/8515017/changing-the-phase-of-a-pattern-image
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetPatternPhase(context, CGSizeMake(xShift, yShift));
    
    CGContextSetFillColorWithColor(context, self.pattern);
    CGContextFillRect(context, self.bounds);
    
    CGContextRestoreGState(context);
}

@end
