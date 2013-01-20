//
//  CLPaletteViewController.m
//  LoveLetter
//
//  Created by user on 1/19/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLPaletteViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CLPaletteViewController ()

@end

@implementation CLPaletteViewController

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
	// Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor purpleColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
