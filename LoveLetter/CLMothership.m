//
//  CLMothership.m
//  LoveLetter
//
//  Created by user on 1/21/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLMothership.h"
#import "CLPalette.h"
#import "AFNetworking.h"

@implementation CLMothership

// Based heavily on https://github.com/gdawg/iOSColourLovers (especially the loadPalette methods), then modified for petty pickiness and/or fun.

static const int kColourLoversDefaultPageSize = 20;

+ (CLMothership *)sharedInstance { // http://stuartkhall.com/posts/ios-development-tips-i-would-want-if-i-was-starting-out-today
    static CLMothership *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[CLMothership alloc] init];
    });
    return _shared;
}

- (void)loadPrettyThingsOfClass:(Class)prettyThingSubclass withVariety:(CLPrettyThingVariety)variety success:(void (^)(NSArray* prettyThings))block {
    [self loadPrettyThingsOfClass:prettyThingSubclass withVariety:variety number:kColourLoversDefaultPageSize offset:0 success:block];
}

- (void)loadPrettyThingsOfClass:(Class)prettyThingSubclass withVariety:(CLPrettyThingVariety)variety number:(NSUInteger)numResults offset:(NSUInteger)offset success:(void (^)(NSArray* prettyThings))block {
    NSLog(@"%@", NSStringFromClass(prettyThingSubclass));
}

-(void) loadPalettes:(void (^)(NSArray* palettes))success {
    [self loadPalettesOfType:ColourPaletteTypeTop success:success];
}

-(void) loadPalettesOfType:(ColourPaletteType)type success:(void (^)(NSArray* palettes))success {
    [self loadPalettesOfType:type withNumber:kColourLoversDefaultPageSize andOffset:0 success:success];
}

-(void) loadPalettesOfType:(ColourPaletteType)type withNumber:(int)numResults andOffset:(int)offset success:(void (^)(NSArray* palettes))success {
    NSString *urlString = [NSString stringWithFormat:@"%@/api/palettes/", COLOURLOVERS_URL_BASE];
    switch (type) {
        case ColourPaletteTypeTop:
            urlString = [urlString stringByAppendingString:@"top"];
            break;
            
        case ColourPaletteTypeNew:
            urlString = [urlString stringByAppendingString:@"new"];
            break;
            
        case ColourPaletteTypeRandom:
            urlString = [urlString stringByAppendingString:@"random"];
            break;
            
        default:
            break;
    }
    urlString = [urlString stringByAppendingString:@"?format=json&showPaletteWidths=1"];
    
    // the api only allows loading one random colour at a time, no offset
    if (type != ColourPaletteTypeRandom) {
        urlString = [urlString stringByAppendingFormat:@"&numResults=%d",numResults];
        urlString = [urlString stringByAppendingFormat:@"&resultOffset=%d",offset];
    }
    
    NSLog(@"loading colours at url %@",urlString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray* parsed = [[NSMutableArray alloc] init];
        for (id node in JSON) {
            [parsed addObject:[[CLPalette alloc] initWithJSON:node]];
        }
        
        // notify the caller of our success and send the list of colours along
        success(parsed);
        
    } failure:nil];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

@end
