//
//  CLColorViewController.m
//  LoveLetter
//
//  Created by user on 2/2/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLColorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CLColor.h"

@interface CLColorViewController ()

@end

@implementation CLColorViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (id)initWithColor:(CLColor *)color {
    self = [super init];
    if (self) {
        self.color = color;
    }
    return self;
}

- (CLPrettyThing *)prettyThing {
    return self.color;
}

- (CLColorViewController *)ghost {
    CLColorViewController *ghost = [[CLColorViewController alloc] initWithColor:self.color];
    ghost.view.frame = self.view.frame;
    [ghost setShowByline:self.showByline animated:NO];
    return ghost;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.layer.backgroundColor = self.color.color.CGColor; // insert Inception joke here
    [super addThingLabels];
}

/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 */

@end
