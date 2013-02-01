//
//  CLPrettyThingViewController.h
//  LoveLetter
//
//  Created by user on 1/31/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

// An Abstract class for handling things that are general to paletteVCs, colorVCs, patternVCs, etc. (such as the byline, loves/comments/views counters, etc.)

#import <UIKit/UIKit.h>
#import "CLPrettyThing.h"

@interface CLPrettyThingViewController : UIViewController

@property (nonatomic) CLPrettyThing *prettyThing;

- (void)addThingLabels;

@end
