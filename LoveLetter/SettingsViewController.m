//
//  SettingsViewController.m
//  LoveLetter
//
//  Created by user on 2/1/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "SettingsViewController.h"

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
    
    NSLog(@"SettingsViewController viewDidLoad");
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
    // todo: if NSUserDefaults, load those.  if not, load default settings, and create NSUserDefaults
    
    // notify delegate of all settings
}

#pragma mark -
#pragma mark UI

- (IBAction)colorSwitchValueChanged:(UISwitch *)sender {
    self.delegate.showColors = sender.on;
}

- (IBAction)paletteSwitchValueChanged:(UISwitch *)sender {
    self.delegate.showPalettes = sender.on;
}

- (IBAction)patternSwitchValueChanged:(UISwitch *)sender {
    self.delegate.showPatterns = sender.on;
}

- (IBAction)varietyValueChanged:(UISegmentedControl *)sender {
    self.delegate.preferredVariety = sender.selectedSegmentIndex; // The segment indexes are ordered identically to the enum.
}

- (IBAction)showPaletteWidthValueChanged:(UISegmentedControl *)sender {
    self.delegate.showVariableWidths = sender.selectedSegmentIndex == 0;
}

- (IBAction)transitionValueChanged:(UISegmentedControl *)sender {
    self.delegate.transitionDuration = [@[@0.0, @1.0, @30.0, @300.0, @3600.0][sender.selectedSegmentIndex] doubleValue]; // todo: revert back to 10s
}

- (IBAction)showBylineValueChanged:(UISegmentedControl *)sender {
    self.delegate.showByline = sender.selectedSegmentIndex == 0;
}

- (IBAction)testButtonTouched:(UIButton *)sender {
    NSLog(@"testButtonTouched");
}

@end
