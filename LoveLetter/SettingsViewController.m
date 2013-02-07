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

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 */

- (IBAction)colorSwitchValueChanged:(UISwitch *)sender {
}

- (IBAction)paletteSwitchValueChanged:(UISwitch *)sender {
}

- (IBAction)patternSwitchValueChanged:(UISwitch *)sender {
}

- (IBAction)varietyValueChanged:(UISegmentedControl *)sender {
    self.delegate.preferredVariety = sender.selectedSegmentIndex; // The segment indexes are ordered identically to the enum.
}

- (IBAction)transitionValueChanged:(UISegmentedControl *)sender {
    self.delegate.transitionDuration = [@[@0.0, @10.0, @30.0, @300.0, @3600.0][sender.selectedSegmentIndex] doubleValue];
}

- (IBAction)testButtonTouched:(UIButton *)sender {
    NSLog(@"testButtonTouched");
}

@end
