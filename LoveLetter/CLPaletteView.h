//
//  CLPaletteView.h
//  LoveLetter
//
//  Created by user on 1/18/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLPalette;

@interface CLPaletteView : UIView

- (id)initWithFrame:(CGRect)frame palette:(CLPalette *)palette;

@property (nonatomic, readonly) CLPalette *palette;

@end
