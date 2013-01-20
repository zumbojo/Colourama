//
//  CLPalette.m
//  LoveLetter
//
//  Created by user on 1/18/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLPalette.h"

@implementation CLPalette

- (id)init
{
    self = [super init]; // http://stackoverflow.com/a/12428407/103058
    if (self) {
        
    }
    return self;
}

+ (CLPalette *)paletteFromArray:(NSArray *)array {
    NSMutableArray *slats = [[NSMutableArray alloc] init];

    for (NSArray *tuple in array) {
        CLSlat *slat = [[CLSlat alloc] init];
        slat.color = UIColorFromRGBString(tuple[0]);
        slat.width = [(NSNumber *)tuple[1] floatValue];
        [slats addObject:slat];
    }

    CLPalette *palette = [[CLPalette alloc] init];
    palette.slats = slats;
    return palette;
    
    
    return nil;
}

@end
