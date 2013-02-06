//
//  KLPatternShiftView.m
//  LoveLetter
//
//  Created by user on 2/4/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "KLPatternShiftView.h"

@interface KLPatternShiftView ()

//@property (nonatomic) CGSize shift;
@property (nonatomic) UIImage *image;
@property (nonatomic) CGColorRef pattern;

@end

@implementation KLPatternShiftView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image shift:(CGSize)shift {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.shift = shift;
        self.image = image;
        self.pattern = [UIColor colorWithPatternImage:image].CGColor;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat scale = [[UIScreen mainScreen] scale]; // http://stackoverflow.com/questions/4779221/in-iphone-app-how-to-detect-the-screen-resolution-of-the-device
    
    CGFloat xShift = fmod(self.bounds.size.width * scale, CGImageGetWidth(self.image.CGImage)) / 2;
    CGFloat yShift = fmod(self.bounds.size.height * scale, CGImageGetHeight(self.image.CGImage)) / 2;
    //((self.bounds.size.width * scale) % CGImageGetWidth(self.image.CGImage)) / 2;
    
//    size_t pxHeight = CGImageGetHeight(image.CGImage);
//    size_t pxWidth = CGImageGetWidth(image.CGImage);

    
    
    //NSLog(@"%.1f", self.bounds.size.width);
    
    CGSize shift = CGSizeMake(xShift, yShift);
    
    // Drawing code
    
    // http://stackoverflow.com/questions/8515017/changing-the-phase-of-a-pattern-image
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetPatternPhase(context, shift);
    
    CGContextSetFillColorWithColor(context, self.pattern);
    CGContextFillRect(context, self.bounds);
    
    CGContextRestoreGState(context);
}

@end
