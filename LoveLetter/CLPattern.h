//
//  CLPattern.h
//  LoveLetter
//
//  Created by user on 2/2/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLPrettyThing.h"

@interface CLPattern : CLPrettyThing

// from API:
@property (nonatomic) NSURL *imageUrl;

// convenience:
@property (nonatomic) UIImage *image;

@end
