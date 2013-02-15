//
//  CLMothership.m
//  LoveLetter
//
//  Created by user on 1/21/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLMothership.h"
#import "CLColor.h"
#import "CLPalette.h"
#import "CLPattern.h"
#import "AFNetworking.h"

typedef void(^CLPrettyThingAcceptor)(NSArray* prettyThings);
typedef void(^CLPrettyThingJSONOperationQueueParser)(NSArray *operations, CLPrettyThingAcceptor success);

@implementation CLMothership

// Based heavily on https://github.com/gdawg/iOSColourLovers (especially the loadPrettyThingsOfClass methods), then modified for petty pickiness and/or fun.

static const int kColourLoversDefaultPageSize = 2;
static NSUInteger colorsNewOffset = 0;
static NSUInteger colorsTopOffset = 0;
static NSUInteger palettesNewOffset = 0;
static NSUInteger palettesTopOffset = 0;
static NSUInteger patternsNewOffset = 0;
static NSUInteger patternsTopOffset = 0;

+ (CLMothership *)sharedInstance { // http://stuartkhall.com/posts/ios-development-tips-i-would-want-if-i-was-starting-out-today
    static CLMothership *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[CLMothership alloc] init];
    });
    return _shared;
}

- (void)loadPrettyThingsOfClass:(Class)prettyThingSubclass withVariety:(CLPrettyThingVariety)variety success:(void (^)(NSArray* prettyThings))success {
    [self loadPrettyThingsOfClass:prettyThingSubclass withVariety:variety number:kColourLoversDefaultPageSize offset:0 success:success];
}

- (void)loadPrettyThingsOfClass:(Class)prettyThingSubclass withVariety:(CLPrettyThingVariety)variety number:(NSUInteger)numResults offset:(NSUInteger)offset success:(void (^)(NSArray* prettyThings))success {
    [self loadPrettyThingsOfClasses:@[prettyThingSubclass] withVariety:variety success:success];
}

- (void)loadPrettyThingsOfClasses:(NSArray *)prettyThingSubclasses withVariety:(CLPrettyThingVariety)variety success:(void (^)(NSArray* prettyThings))success {
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    for (Class prettyThingSubclass in prettyThingSubclasses) {
        NSURLRequest *request = [self requestForPrettyThingsOfClass:prettyThingSubclass withVariety:variety number:kColourLoversDefaultPageSize offset:0];
        // todo: need to keep track of offset for New and Top varieties.
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:nil failure:nil];
        operation.userInfo = @{@"class" : prettyThingSubclass};
        [operations addObject:operation];
    }
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [client enqueueBatchOfHTTPRequestOperations:operations
                                  progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
                                      NSLog(@"%d / %d", numberOfCompletedOperations, totalNumberOfOperations);
                                  }
                                completionBlock:^(NSArray *operations) {
                                    [CLMothership parser](operations, success);
                                }];
}

#pragma mark -
#pragma mark Offsets

- (void)resetOffsets {
    colorsNewOffset = 0;
    colorsTopOffset = 0;
    palettesNewOffset = 0;
    palettesTopOffset = 0;
    patternsNewOffset = 0;
    patternsTopOffset = 0;
}

- (NSUInteger)offsetForClass:(Class)class andVariety:(CLPrettyThingVariety)variety {
    if (variety == CLPrettyThingVarietyNew || variety == CLPrettyThingVarietyTop) {
        if (class == [CLColor class]) {
            return variety == CLPrettyThingVarietyNew ? colorsNewOffset : colorsTopOffset;
        }
        if (class == [CLPalette class]) {
            return variety == CLPrettyThingVarietyNew ? palettesNewOffset : palettesTopOffset;
        }
        if (class == [CLPattern class]) {
            return variety == CLPrettyThingVarietyNew ? patternsNewOffset : patternsTopOffset;
        }
    }
    
    NSLog(@"WARNING: offsetForClass was called on invalid combination.");
    return 0;
}

- (void)setOffset:(NSUInteger)offset forClass:(Class)class andVariety:(CLPrettyThingVariety)variety {
    if (variety == CLPrettyThingVarietyNew) {
        if (class == [CLColor class]) {
            colorsNewOffset = offset;
        }
        if (class == [CLPalette class]) {
            palettesNewOffset = offset;
        }
        if (class == [CLPattern class]) {
            patternsNewOffset = offset;
        }
    }
    else if  (variety == CLPrettyThingVarietyTop) {
        if (class == [CLColor class]) {
            colorsTopOffset = offset;
        }
        if (class == [CLPalette class]) {
            palettesTopOffset = offset;
        }
        if (class == [CLPattern class]) {
            patternsTopOffset = offset;
        }
    }
}

- (void)increment:(NSUInteger)increment offsetForClass:(Class)class andVariety:(CLPrettyThingVariety)variety {
    NSUInteger new = [self offsetForClass:class andVariety:variety] + increment;
    [self setOffset:new forClass:class andVariety:variety];
}

#pragma mark -
#pragma mark Helpers

- (NSURLRequest *)requestForPrettyThingsOfClass:(Class)prettyThingSubclass withVariety:(CLPrettyThingVariety)variety number:(NSUInteger)numResults offset:(NSUInteger)offset {
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
    
    NSLog(@"request pretty things at url %@",urlString);
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}

+ (CLPrettyThingJSONOperationQueueParser)parser {
    return ^(NSArray *operations, CLPrettyThingAcceptor success) {
        NSMutableArray* parsed = [[NSMutableArray alloc] init];
        BOOL waitForPatternQueueCompletion = NO;
        
        for (AFJSONRequestOperation *op in operations) { // first pass; parse CLColors and CLPalettes
            if (op.error) {
                NSLog(@"++++++++++++++ Operation error");
            }
            else {
                Class prettyThingSubclass = op.userInfo[@"class"];
                
                if (prettyThingSubclass != [CLPattern class]) {
                    for (id node in op.responseJSON) {
                        [parsed addObject:[[prettyThingSubclass alloc] initWithJSON:node]];
                    }
                }
            }
        }
        
        for (AFJSONRequestOperation *op in operations) { // second pass; parse CLPatterns
            if (op.error) {
                NSLog(@"++++++++++++++ Operation error");
            }
            else {
                Class prettyThingSubclass = op.userInfo[@"class"];
                
                if (prettyThingSubclass == [CLPattern class]) {
                    waitForPatternQueueCompletion = YES;
                    
                    for (id node in op.responseJSON) {
                        [parsed addObject:[[prettyThingSubclass alloc] initWithJSON:node]];
                    }
                    
                    // queue up images for download:
                    NSMutableArray *imageOperations = [[NSMutableArray alloc] init];
                    for (CLPrettyThing* thing in parsed) {
                        if ([thing isKindOfClass:[CLPattern class]]) {
                            CLPattern *pattern = (CLPattern *)thing;
                            AFImageRequestOperation *imageOp = [[AFImageRequestOperation alloc] initWithRequest:[[NSURLRequest alloc] initWithURL:pattern.imageUrl]];
                            imageOp.userInfo = @{@"pattern" : pattern};
                            [imageOperations addObject:imageOp];
                        }
                    }
                    
                    // How to use "enqueueBatchOfHTTPRequestOperationsWithRequests":
                    // https://github.com/AFNetworking/AFNetworking/issues/305
                    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
                    [client enqueueBatchOfHTTPRequestOperations:imageOperations
                                                  progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
                                                      //NSLog(@"%d / %d", numberOfCompletedOperations, totalNumberOfOperations);
                                                  }
                                                completionBlock:^(NSArray *operations) {
                                                    BOOL allRequestsCompletedWithoutError = true;
                                                    for (AFImageRequestOperation *ro in operations) {
                                                        if (ro.error) {
                                                            NSLog(@"++++++++++++++ Operation error");
                                                            allRequestsCompletedWithoutError = false;
                                                        }
                                                        else {
                                                            ((CLPattern *)ro.userInfo[@"pattern"]).image = ro.responseImage; // assign responseImage to pattern.image
                                                            //NSLog(@"Operation OK: %@", [ro.responseData description]);
                                                        }
                                                    }
                                                    
                                                    if (allRequestsCompletedWithoutError) {
                                                        success(parsed);
                                                    }
                                                }];
                }
            }
        }
        
        if (!waitForPatternQueueCompletion) {
            success(parsed);
        }
    };
}

@end
