//
//  CLColorViewController.h
//  LoveLetter
//
//  Created by user on 2/2/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPrettyThingViewController.h"

@class CLColor;

@interface CLColorViewController : CLPrettyThingViewController

@property (nonatomic) CLColor *color;

- (id)initWithColor:(CLColor *)color;

@end
