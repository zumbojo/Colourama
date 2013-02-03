//
//  CLPalette.h
//  LoveLetter
//
//  Created by user on 1/18/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLPrettyThing.h"
#import "CLSlat.h"

@interface CLPalette : CLPrettyThing

// from API:
// (All were moved to CLPrettyThing.)

// convenience:
@property (nonatomic) NSArray *slats;

- (CLPrettyThing *)initWithJSON:(id)json;
+ (CLPalette *)paletteFromArray:(NSArray *)array; // array of @[string, NSNumber]s
+ (CLPalette *)paletteFromJSON:(id)json;

@end
