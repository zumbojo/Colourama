//
//  SettingsViewController.m
//  LoveLetter
//
//  Created by user on 2/1/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "SettingsViewController.h"

#define TRANSITION_DURATION_INDEX_KEY   @"transitionDurationIndex"
#define PREFERRED_VARIETY_KEY           @"preferredVariety"
#define SHOW_COLORS_KEY                 @"showColors"
#define SHOW_PALETTES_KEY               @"showPalettes"
#define SHOW_PATTERNS_KEY               @"showPatterns"
#define SHOW_VARIABLE_WIDTHS_KEY        @"showVariableWidths"
#define SHOW_BYLINE_KEY                 @"showByline"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<SettingsViewControllerDelegate>)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = delegate;
        [self loadSettings];
    }
    return self;
}
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.switchWarningLabel.alpha = 0;
    
    [self updateUIFromSettings];
}

/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 */

#pragma mark -
#pragma mark Defaults

- (void)loadSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:SHOW_COLORS_KEY]) { // setup NSUserDefaults if none exist
        NSLog(@"no NSUserDefaults");
        [defaults setInteger:0 forKey:TRANSITION_DURATION_INDEX_KEY];
        [defaults setInteger:CLPrettyThingVarietyTop forKey:PREFERRED_VARIETY_KEY];
        [defaults setBool:YES forKey:SHOW_COLORS_KEY];
        [defaults setBool:YES forKey:SHOW_PALETTES_KEY];
        [defaults setBool:YES forKey:SHOW_PATTERNS_KEY];
        [defaults setBool:YES forKey:SHOW_VARIABLE_WIDTHS_KEY];
        [defaults setBool:YES forKey:SHOW_BYLINE_KEY];
        [defaults synchronize];
    }
    
    // update delegate using NSUserDefaults:
    self.delegate.transitionDuration = [self transitionDurationForIndex:[defaults integerForKey:TRANSITION_DURATION_INDEX_KEY]];
    self.delegate.preferredVariety = [defaults integerForKey:PREFERRED_VARIETY_KEY];
    self.delegate.showColors = [defaults boolForKey:SHOW_COLORS_KEY];
    self.delegate.showPalettes = [defaults boolForKey:SHOW_PALETTES_KEY];
    self.delegate.showPatterns = [defaults boolForKey:SHOW_PATTERNS_KEY];
    self.delegate.showVariableWidths = [defaults boolForKey:SHOW_VARIABLE_WIDTHS_KEY];
    self.delegate.showByline = [defaults boolForKey:SHOW_BYLINE_KEY];
    self.delegate.initialSettingsLoadIsComplete = YES;
}

- (void)updateUIFromSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.transitionSpeedSeg.selectedSegmentIndex = [defaults integerForKey:TRANSITION_DURATION_INDEX_KEY];
    self.varietySeg.selectedSegmentIndex = [defaults integerForKey:PREFERRED_VARIETY_KEY];
    self.colorSwitch.on = [defaults boolForKey:SHOW_COLORS_KEY];
    self.paletteSwitch.on = [defaults boolForKey:SHOW_PALETTES_KEY];
    self.patternSwitch.on = [defaults boolForKey:SHOW_PATTERNS_KEY];
    self.paletteWidthSeg.selectedSegmentIndex = ![defaults boolForKey:SHOW_VARIABLE_WIDTHS_KEY];
    self.bylineSeg.selectedSegmentIndex = ![defaults boolForKey:SHOW_BYLINE_KEY];
}

#pragma mark -
#pragma mark UI

- (IBAction)colorSwitchValueChanged:(UISwitch *)sender {
    if ([self switchSettingsAreValid:sender]) {
        self.delegate.showColors = sender.on;
        [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:SHOW_COLORS_KEY];
    }
}

- (IBAction)paletteSwitchValueChanged:(UISwitch *)sender {
    if ([self switchSettingsAreValid:sender]) {
        self.delegate.showPalettes = sender.on;
        [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:SHOW_PALETTES_KEY];
    }
}

- (IBAction)patternSwitchValueChanged:(UISwitch *)sender {
    if ([self switchSettingsAreValid:sender]) {
        self.delegate.showPatterns = sender.on;
        [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:SHOW_PATTERNS_KEY];
    }
}

- (IBAction)varietyValueChanged:(UISegmentedControl *)sender {
    self.delegate.preferredVariety = sender.selectedSegmentIndex; // The segment indexes are ordered identically to the enum.
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:PREFERRED_VARIETY_KEY];
}

- (IBAction)showPaletteWidthValueChanged:(UISegmentedControl *)sender {
    self.delegate.showVariableWidths = sender.selectedSegmentIndex == 0;
    [[NSUserDefaults standardUserDefaults] setBool:(sender.selectedSegmentIndex == 0) forKey:SHOW_VARIABLE_WIDTHS_KEY];
}

- (IBAction)transitionValueChanged:(UISegmentedControl *)sender {
    self.delegate.transitionDuration = [self transitionDurationForIndex:sender.selectedSegmentIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:TRANSITION_DURATION_INDEX_KEY];
}

- (IBAction)showBylineValueChanged:(UISegmentedControl *)sender {
    self.delegate.showByline = sender.selectedSegmentIndex == 0;
    [[NSUserDefaults standardUserDefaults] setBool:(sender.selectedSegmentIndex == 0) forKey:SHOW_BYLINE_KEY];
}

#pragma mark -
#pragma mark Helpers

- (BOOL)switchSettingsAreValid:(UISwitch *)sender {
    if (self.colorSwitch.on || self.paletteSwitch.on || self.patternSwitch.on) {
        return YES;
    }
    
    // Disabling all three pretty thing types prevents anything from getting loaded and is Bad Times(TM).  See issue #55
    // Revert the switch that caused these bad times and flash a warning.
    
    [sender setOn:YES animated:YES];
    
    // todo: flash warning
    
    return NO;
}

- (NSTimeInterval)transitionDurationForIndex:(NSUInteger)index {
    return [@[@0.0, @10.0, @30.0, @300.0, @3600.0][index] doubleValue];
}

@end
