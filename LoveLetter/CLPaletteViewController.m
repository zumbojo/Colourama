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
    
    NSArray *allNamedColors = @[ // well, except clearColor and whiteColor
        [UIColor blackColor],
        [UIColor blueColor],
        [UIColor brownColor],
        [UIColor cyanColor],
        [UIColor darkGrayColor],
        [UIColor grayColor],
        [UIColor greenColor],
        [UIColor lightGrayColor],
        [UIColor blueColor],
        [UIColor blueColor],
        [UIColor magentaColor],
        [UIColor orangeColor],
        [UIColor purpleColor],
        [UIColor redColor],
        [UIColor yellowColor]
    ];
    
    // random background color
    self.view.layer.backgroundColor = ((UIColor *)allNamedColors[arc4random_uniform(allNamedColors.count)]).CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
