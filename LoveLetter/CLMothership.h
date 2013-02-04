//
//  CLMothership.h
//  LoveLetter
//
//  Created by user on 1/21/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { // todo: deprecate
    ColourPaletteTypeNew,
    ColourPaletteTypeTop,
    ColourPaletteTypeRandom
} ColourPaletteType;

typedef enum {
    CLPrettyThingVarietyNew,
    CLPrettyThingVarietyTop,
    CLPrettyThingVarietyRandom
} CLPrettyThingVariety;

@interface CLMothership : NSObject

+ (CLMothership *)sharedInstance;

- (void)loadPrettyThingsOfClass:(Class)prettyThingSubclass withVariety:(CLPrettyThingVariety)variety success:(void (^)(NSArray* prettyThings))success;
- (void)loadPrettyThingsOfClass:(Class)prettyThingSubclass withVariety:(CLPrettyThingVariety)variety number:(NSUInteger)numResults offset:(NSUInteger)offset success:(void (^)(NSArray* prettyThings))success;
- (void)loadPalettes:(void (^)(NSArray* palettes))block; // loads the top 20 palettes with default options
- (void)loadPalettesOfType:(ColourPaletteType)type success:(void (^)(NSArray* palettes))block;
- (void)loadPalettesOfType:(ColourPaletteType)type withNumber:(int)numResults andOffset:(int)offset success:(void (^)(NSArray* palettes))block;

@end
