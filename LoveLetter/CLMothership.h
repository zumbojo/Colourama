//
//  CLMothership.h
//  LoveLetter
//
//  Created by user on 1/21/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CLPrettyThingVarietyNew,
    CLPrettyThingVarietyTop,
    CLPrettyThingVarietyRandom
} CLPrettyThingVariety;

@interface CLMothership : NSObject

+ (CLMothership *)sharedInstance;
- (void)loadPrettyThingsOfClass:(Class)prettyThingSubclass withVariety:(CLPrettyThingVariety)variety success:(void (^)(NSArray* prettyThings))success;
- (void)loadPrettyThingsOfClass:(Class)prettyThingSubclass withVariety:(CLPrettyThingVariety)variety number:(NSUInteger)numResults offset:(NSUInteger)offset success:(void (^)(NSArray* prettyThings))success;

@end
