//
//  CLPatternViewController.m
//  LoveLetter
//
//  Created by user on 2/3/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLPatternViewController.h"
#import "CLPattern.h"
#import "KLPatternShiftView.h"

@interface CLPatternViewController ()

@end

@implementation CLPatternViewController

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

- (id)initWithPattern:(CLPattern *)pattern {
    self = [super init];
    if (self) {
        self.pattern = pattern;
    }
    return self;
}

- (CLPrettyThing *)prettyThing {
    return self.pattern;
}

- (CLPatternViewController *)ghost {
    CLPatternViewController *ghost = [[CLPatternViewController alloc] initWithPattern:self.pattern];
    ghost.view.frame = self.view.frame;
    return ghost;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    KLPatternShiftView *shifty = [[KLPatternShiftView alloc] initWithFrame:self.view.frame image:self.pattern.image shift:CGSizeMake(50, 50)];
    shifty.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    shifty.contentMode = UIViewContentModeRedraw;
    self.view.autoresizesSubviews = YES;
    
    
    [self.view addSubview:shifty];
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
