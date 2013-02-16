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
@property (nonatomic) BOOL showVariableWidths;
@property (nonatomic) BOOL showByline;

@end


@interface SettingsViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<SettingsViewControllerDelegate>)delegate;

- (IBAction)colorSwitchValueChanged:(UISwitch *)sender;
- (IBAction)paletteSwitchValueChanged:(UISwitch *)sender;
- (IBAction)patternSwitchValueChanged:(UISwitch *)sender;
- (IBAction)varietyValueChanged:(UISegmentedControl *)sender;
- (IBAction)showPaletteWidthValueChanged:(UISegmentedControl *)sender;
- (IBAction)transitionValueChanged:(UISegmentedControl *)sender;
- (IBAction)showBylineValueChanged:(UISegmentedControl *)sender;
- (IBAction)testButtonTouched:(UIButton *)sender;

@property(weak) id<SettingsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *colorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *paletteSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *patternSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *varietySeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paletteWidthSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *transitionSpeedSeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *bylineSeg;

@end