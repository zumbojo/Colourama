//
//  CLPrettyThing.h
//  LoveLetter
//
//  Created by user on 1/31/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLPrettyThing : NSObject

// from API:
@property (nonatomic) NSUInteger remoteId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSUInteger numViews;
@property (nonatomic) NSUInteger numVotes;
@property (nonatomic) NSUInteger numComments;
@property (nonatomic) NSUInteger numHearts;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) NSURL *url;

// convenience:
@property (nonatomic, readonly) NSString *pluralApiPath; // "colors", "palettes", "patterns", etc.
@property (nonatomic, readonly) NSString *specialApiArguments; // "&showPaletteWidths=1", etc.
@property (nonatomic, readonly) NSString *shortPrintableUrl; // "colourlovers.com/palette/92095" instead of http://www.colourlovers.com/palette/92095/Giant_Goldfish

- (CLPrettyThing *)initWithJSON:(id)json; // Don't call directly; only call via [super initWithJSON:json] in subclasses.

@end
