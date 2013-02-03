//
//  CLColor.h
//  LoveLetter
//
//  Created by user on 2/2/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLPrettyThing.h"

@interface CLColor : CLPrettyThing

// from API:
@property (nonatomic) NSString *hex;

// convenience:
@property (nonatomic) UIColor *color;

- (CLColor *)initWithJSON:(id)json;

@end
