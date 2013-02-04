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
    // example from http://www.colourlovers.com/api/palette/2646927?format=json&showPaletteWidths=1
    // (after being run through http://jsonlint.com/ , of course)
    /*
    [
     {
         "id": 2646927,
         "title": "Ashley's Peanut Cake",
         "userName": "Ethulai",
         "numViews": 13,
         "numVotes": 5,
         "numComments": 3,
         "numHearts": 0,
         "rank": 0,
         "dateCreated": "2013-01-20 17:03:17",
         "colors": [
                    "5F5453",
                    "EEB548",
                    "F7C95F",
                    "D5BD95",
                    "6D6379"
                    ],
         "colorWidths": [
                         0.37,
                         0.1,
                         0.05,
                         0.03,
                         0.45
                         ],
         "description": "<a style=\"border:none\" href=\"http://www.colourlovers.com/forums/1,1,3731\" title=\"1LPxCLer Above Me GAME\" target=\"_blank\"><img style=\"max-width:95%;\" alt=\"1LPxCLer Above Me GAME\" src=\"http://i.imgur.com/DGcFk.png\" /></a>",
         "url": "http://www.colourlovers.com/palette/2646927/Ashleys_Peanut_Cake",
         "imageUrl": "http://www.colourlovers.com/paletteImg/5F5453/EEB548/F7C95F/D5BD95/6D6379/Ashleys_Peanut_Cake.png",
         "badgeUrl": "http://www.colourlovers.com/images/badges/pw/2646/2646927_Ashleys_Peanut_Cake.png",
         "apiUrl": "http://www.colourlovers.com/api/palette/2646927"
     }
     ]
    */
    
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

+ (NSString *)pluralApiPath {
    return @"palettes";
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
