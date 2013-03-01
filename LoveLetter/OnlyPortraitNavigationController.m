//
//  OnlyPortraitNavigationController.m
//  LoveLetter
//
//  Created by user on 2/28/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "OnlyPortraitNavigationController.h"

@interface OnlyPortraitNavigationController ()

@end

@implementation OnlyPortraitNavigationController

- (BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
