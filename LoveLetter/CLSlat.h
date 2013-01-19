//
//  CLSlat.h
//  LoveLetter
//
//  Created by user on 1/18/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

// "A slat is a long, thin, flat piece of material." http://en.wikipedia.org/wiki/Slat
// One or more slats comprise a CLPalette.  If I just used UIColors, I wouldn't be able to have slats of differing widths.  Hence, CLSlat.

#import <Foundation/Foundation.h>

@interface CLSlat : NSObject

@property (nonatomic) UIColor *color;
@property (nonatomic) CGFloat width;

@end
