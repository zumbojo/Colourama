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
    
    if (![defaults objectForKey:@"showColors"]) { // setup NSUserDefaults if none exist
        NSLog(@"no NSUserDefaults");
        [defaults setInteger:0 forKey:@"transitionDurationIndex"];
        [defaults setInteger:CLPrettyThingVarietyRandom forKey:@"preferredVariety"];
        [defaults setBool:YES forKey:@"showColors"];
        [defaults setBool:YES forKey:@"showPalettes"];
        [defaults setBool:YES forKey:@"showPatterns"];
        [defaults setBool:YES forKey:@"showVariableWidths"];
        [defaults setBool:YES forKey:@"showByline"];
        [defaults synchronize];
    }
    
    // update delegate using NSUserDefaults:
    self.delegate.transitionDuration = [self transitionDurationForIndex:[defaults integerForKey:@"transitionDurationIndex"]];
    self.delegate.preferredVariety = [defaults integerForKey:@"preferredVariety"];
    self.delegate.showColors = [defaults boolForKey:@"showColors"];
    self.delegate.showPalettes = [defaults boolForKey:@"showPalettes"];
    self.delegate.showPatterns = [defaults boolForKey:@"showPatterns"];
    self.delegate.showVariableWidths = [defaults boolForKey:@"showVariableWidths"];
    self.delegate.showByline = [defaults boolForKey:@"showByline"];
}

- (void)updateUIFromSettings {
    
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
    self.delegate.transitionDuration = [self transitionDurationForIndex:sender.selectedSegmentIndex];
}

- (IBAction)showBylineValueChanged:(UISegmentedControl *)sender {
    self.delegate.showByline = sender.selectedSegmentIndex == 0;
}

- (IBAction)testButtonTouched:(UIButton *)sender {
    NSLog(@"testButtonTouched");
}

#pragma mark -
#pragma mark Helpers

- (NSTimeInterval)transitionDurationForIndex:(NSUInteger)index {
    return [@[@0.0, @1.0, @30.0, @300.0, @3600.0][index] doubleValue]; // todo: revert back to 10s
}

@end
