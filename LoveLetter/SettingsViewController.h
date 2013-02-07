//
//  SettingsViewController.h
//  LoveLetter
//
//  Created by user on 2/1/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMothership.h"

@protocol SettingsViewControllerDelegate

@property (nonatomic) NSTimeInterval transitionDuration;
@property (nonatomic) CLPrettyThingVariety preferredVariety;
@property (nonatomic) BOOL showColors;
@property (nonatomic) BOOL showPalettes;
@property (nonatomic) BOOL showPatterns;

@end


@interface SettingsViewController : UIViewController

- (IBAction)testButtonTouched:(id)sender;
- (IBAction)transitionValueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *transitionSpeedSlider; // todo: deprecate
@property(weak) id<SettingsViewControllerDelegate> delegate;

@end