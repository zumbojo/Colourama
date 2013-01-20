//
//  CLPaletteViewController.h
//  LoveLetter
//
//  Created by user on 1/19/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLPalette;

@interface CLPaletteViewController : UIViewController

@property (nonatomic) CLPalette *palette;

- (id)initWithPalette:(CLPalette *)palette;

@end
