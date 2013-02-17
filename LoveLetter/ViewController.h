//
//  ViewController.h
//  LoveLetter
//
//  Created by user on 1/18/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "CLMothership.h"

@interface ViewController : UIViewController <SettingsViewControllerDelegate, UIActionSheetDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)shareButtonTouched:(id)sender;
- (IBAction)settingsButtonTouched:(id)sender;

// SettingsViewControllerDelegate:
@property (nonatomic) NSTimeInterval transitionDuration;
@property (nonatomic) CLPrettyThingVariety preferredVariety;
@property (nonatomic) BOOL showColors;
@property (nonatomic) BOOL showPalettes;
@property (nonatomic) BOOL showPatterns;
@property (nonatomic) BOOL showVariableWidths;
@property (nonatomic) BOOL showByline;
@property (nonatomic) BOOL initialSettingsLoadIsComplete;

@end
