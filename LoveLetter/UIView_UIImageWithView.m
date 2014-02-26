//
//  UIView_UIImageWithView.m
//  Colourama
//
//  Created by user on 2/25/14.
//  Copyright (c) 2014 Kevin Lawson. All rights reserved.
//

#import "UIView_UIImageWithView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView_UIImageWithView

+ (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
