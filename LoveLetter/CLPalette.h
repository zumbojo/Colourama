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

// from API:
@property (nonatomic) NSUInteger id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSUInteger numViews;
@property (nonatomic) NSUInteger *numVotes;
@property (nonatomic) NSUInteger *numComments;
@property (nonatomic) NSUInteger *numHearts;
@property (nonatomic) NSUInteger *rank;

// convenience:
@property (nonatomic) NSArray *slats;

+ (CLPalette *)paletteFromArray:(NSArray *)array; // array of @[string, NSNumber]s
+ (CLPalette *)paletteFromJSON:(id)json;

@end
