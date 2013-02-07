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

- (IBAction)testButtonTouched:(id)sender {
    NSLog(@"testButtonTouched");
}

- (IBAction)transitionSpeedSegmentedControlValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    NSUInteger notch = (NSUInteger)slider.value; // http://stackoverflow.com/questions/2519460/uislider-with-increments-of-5
    slider.value = notch;
    
    self.delegate.transitionDuration = [@[@0.0, @10.0, @30.0, @300.0, @3600.0][notch] doubleValue];
}

@end
