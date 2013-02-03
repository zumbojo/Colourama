//
//  CLPalette.m
//  LoveLetter
//
//  Created by user on 1/18/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLPalette.h"

@implementation CLPalette

- (CLPalette *)initWithJSON:(id)json {
    self = [super initWithJSON:json];
    if (self) {
        NSMutableArray *slats = [[NSMutableArray alloc] init];
        NSArray *colors = [json valueForKeyPath:@"colors"];
        NSArray *colorWidths = [json valueForKeyPath:@"colorWidths"];
        NSUInteger index = 0;
        for (NSString *hexColor in colors) {
            CLSlat *slat = [[CLSlat alloc] init];
            slat.color = UIColorFromRGBString(hexColor);
            slat.width = [colorWidths[index] floatValue];
            [slats addObject:slat];
            index++;
        }
        self.slats = slats;
    }
    return self;
}

- (NSURL *)webPageURL {
    // example: http://www.colourlovers.com/palette/2668882
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/palette/%d", COLOURLOVERS_URL_BASE, self.remoteId]];
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
}

@end
