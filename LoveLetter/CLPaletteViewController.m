//
//  CLPaletteViewController.m
//  LoveLetter
//
//  Created by user on 1/19/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLPaletteViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CLPalette.h"

@interface CLPaletteViewController ()

@property (nonatomic) NSMutableArray *slatViews;

@end

@implementation CLPaletteViewController

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

- (id)initWithPalette:(CLPalette *)palette {
    self = [super init];
    if (self) {
        self.palette = palette;
        self.slatViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // add slat views:
    for (CLSlat *slat in self.palette.slats) {
        UIView *slatView = [[UIView alloc] init];
        slatView.layer.backgroundColor = slat.color.CGColor;
        slatView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.slatViews addObject:slatView];
        [self.view addSubview:slatView];
    }
    
    // add constraints
    for (UIView *slatView in self.slatViews) {
        NSDictionary *views = NSDictionaryOfVariableBindings(slatView);
        
        // vertical is easy:
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[slatView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
        
        // horizontal is a bit more involved:
        
        if (slatView == self.slatViews[0]) { // if first, glue left to superview left
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:slatView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        }
        else { // if not first, glue left to last, set width equal to first
            UIView *last = self.slatViews[[self.slatViews indexOfObject:slatView] - 1];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:slatView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:last attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
            
            UIView *first = self.slatViews[0];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:slatView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:first attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        }
        
        if (slatView == self.slatViews.lastObject) { // if last, glue right to superview right
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:slatView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
