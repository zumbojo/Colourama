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

- (void)loadPrettyThingsOfClass:(Class)prettyThingSubclass withVariety:(CLPrettyThingVariety)variety number:(NSUInteger)numResults offset:(NSUInteger)offset success:(void (^)(NSArray* prettyThings))success {
    NSLog(@"%@", NSStringFromClass(prettyThingSubclass));
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/%@/", COLOURLOVERS_URL_BASE, ((CLPrettyThing *)prettyThingSubclass).pluralApiPath];
    switch (variety) {
        case CLPrettyThingVarietyTop:
            urlString = [urlString stringByAppendingString:@"top"];
            break;
            
        case CLPrettyThingVarietyNew:
            urlString = [urlString stringByAppendingString:@"new"];
            break;
            
        case CLPrettyThingVarietyRandom:
            urlString = [urlString stringByAppendingString:@"random"];
            break;
            
        default:
            break;
    }
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?format=json%@", ((CLPrettyThing *)prettyThingSubclass).specialApiArguments]];
    
    // the api only allows loading one random colour at a time, no offset
    if (variety != CLPrettyThingVarietyRandom) {
        urlString = [urlString stringByAppendingFormat:@"&numResults=%d",numResults];
        urlString = [urlString stringByAppendingFormat:@"&resultOffset=%d",offset];
    }
    
    NSLog(@"loading pretty things at url %@",urlString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray* parsed = [[NSMutableArray alloc] init];
        for (id node in JSON) {
            [parsed addObject:[[prettyThingSubclass alloc] initWithJSON:node]];
        }
        
        // notify the caller of our success and send the list of colours along
        success(parsed);
        
    } failure:nil];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

@end
