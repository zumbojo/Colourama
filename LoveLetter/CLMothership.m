//
//  CLMothership.m
//  LoveLetter
//
//  Created by user on 1/21/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLMothership.h"
#import "CLPattern.h"
#import "AFNetworking.h"

@implementation CLMothership

// Based heavily on https://github.com/gdawg/iOSColourLovers (especially the loadPrettyThingsOfClass methods), then modified for petty pickiness and/or fun.

static const int kColourLoversDefaultPageSize = 20;

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
    
    NSURLRequest *request = [self requestForPrettyThingsOfClass:prettyThingSubclass withVariety:variety number:numResults offset:offset];
    
    AFJSONRequestOperation *operation = [self operationForPrettyThingsOfClass:prettyThingSubclass request:request success:success];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
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
                                    NSMutableArray* parsed = [[NSMutableArray alloc] init];
                                    
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
                                            
                                            //NSLog(@"Operation OK: %@", [op.responseData description]);
                                        }
                                    }
                                    
                                    success(parsed);

                                    
                                    
                                    
                                    
                                    
                                    /*
                                    BOOL allRequestsCompletedWithoutError = true;
                                    for (AFJSONRequestOperation *op in operations) {
                                        if (op.error) {
                                            NSLog(@"++++++++++++++ Operation error");
                                            allRequestsCompletedWithoutError = false;
                                        }
                                        else {
                                            NSLog(@"Operation OK: %@", [op.responseData description]);
                                        }
                                    }
                                    
                                    if (allRequestsCompletedWithoutError) {
                                        //success(parsed);
                                    }
                                     */
                                }];
}

#pragma mark -
#pragma Helpers

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

- (AFJSONRequestOperation *)operationForPrettyThingsOfClass:(Class)prettyThingSubclass request:(NSURLRequest *)request success:(void (^)(NSArray* prettyThings))success {
    return [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray* parsed = [[NSMutableArray alloc] init];
        for (id node in JSON) {
            [parsed addObject:[[prettyThingSubclass alloc] initWithJSON:node]];
        }
        
        if ([prettyThingSubclass class] == [CLPattern class]) {
            // queue up images for download:
            NSMutableArray *imageOperations = [[NSMutableArray alloc] init];
            for (CLPattern* pattern in parsed) {
                AFImageRequestOperation *imageOp = [[AFImageRequestOperation alloc] initWithRequest:[[NSURLRequest alloc] initWithURL:pattern.imageUrl]];
                imageOp.userInfo = @{@"pattern" : pattern};
                [imageOperations addObject:imageOp];
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
        else {
            // notify the caller of our success and send the list of pretty things along
            success(parsed);
        }
    } failure:nil];
}

@end
