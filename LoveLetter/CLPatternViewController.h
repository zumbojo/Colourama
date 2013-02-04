//
//  CLPatternViewController.h
//  LoveLetter
//
//  Created by user on 2/3/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPrettyThingViewController.h"

@class CLPattern;

@interface CLPatternViewController : CLPrettyThingViewController

@property (nonatomic) CLPattern *pattern;

- (id)initWithPattern:(CLPattern *)pattern;

@end
