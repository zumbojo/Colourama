//
//  CLPalette.h
//  LoveLetter
//
//  Created by user on 1/18/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLSlat.h"

@interface CLPalette : NSObject

@property (nonatomic) NSArray *slats;

+ (CLPalette *)paletteFromArray:(NSArray *)array; // array of @[string, NSNumber]s

// todo: initFromJSON or something

@end
