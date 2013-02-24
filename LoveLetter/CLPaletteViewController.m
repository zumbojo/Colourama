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
@property (nonatomic) NSMutableArray *variableWidthConstraints;
@property (nonatomic) NSMutableArray *uniformWidthConstraints;

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
        self.variableWidthConstraints = [[NSMutableArray alloc] init];
        self.uniformWidthConstraints = [[NSMutableArray alloc] init];
        _showVariableWidths = YES;
    }
    return self;
}

- (CLPrettyThing *)prettyThing {
    return self.palette;
}

- (CLPaletteViewController *)ghost {
    CLPaletteViewController *ghost = [[CLPaletteViewController alloc] initWithPalette:self.palette];
    ghost.view.frame = self.view.frame;
    [ghost setShowByline:self.showByline animated:NO];
    [ghost setShowVariableWidths:self.showVariableWidths animated:NO];
    return ghost;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set background to that of the last slat.  Autolayout was (intermittently :/) failing to properly fill the last slat, resulting in white gaps bleeding through.
    // This hides those.
    self.view.layer.backgroundColor = ((CLSlat *)self.palette.slats.lastObject).color.CGColor;
    
    // add slat views:
    for (CLSlat *slat in self.palette.slats) {
        UIView *slatView = [[UIView alloc] init];
        slatView.layer.backgroundColor = slat.color.CGColor;
        slatView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.slatViews addObject:slatView];
        [self.view addSubview:slatView];
        
        // add width width constraint:
        if (slat != self.palette.slats.lastObject) { // last (rightmost) slat's width not explicitly set, in order to avoid "Unable to simultaneously satisfy constraints." warnings.  The last's left and right attributes are set as part of later constraints, so it all works out; last takes up all of the remaining space; last's slat.width is ignored.
            NSLayoutConstraint *variableWidthConstraint = [NSLayoutConstraint constraintWithItem:slatView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:slat.width constant:0];
            [self.variableWidthConstraints addObject:variableWidthConstraint];
            
            if (self.showVariableWidths) {
                [self.view addConstraint:variableWidthConstraint];
            }
        }
    }
    
    // add remaining constraints (height, positioning):
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
        else { // if not first, glue left to last
            UIView *last = self.slatViews[[self.slatViews indexOfObject:slatView] - 1];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:slatView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:last attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

            UIView *first = self.slatViews[0];
            NSLayoutConstraint *uniformWidthConstraint = [NSLayoutConstraint constraintWithItem:slatView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:first attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
            [self.uniformWidthConstraints addObject:uniformWidthConstraint];
            
            if (!self.showVariableWidths) {
                [self.view addConstraint:uniformWidthConstraint];
            }
        }
        
        if (slatView == self.slatViews.lastObject) { // if last, glue right to superview right
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:slatView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        }
    }
    
    [super addThingLabels];
}

- (void)setShowVariableWidths:(BOOL)show animated:(BOOL)animated {
    if (show == self.showVariableWidths) {
        return;
    }

    _showVariableWidths = show;
    [self.view removeConstraints:(self.showVariableWidths ? self.uniformWidthConstraints : self.variableWidthConstraints)];
    [self.view addConstraints:(self.showVariableWidths ? self.variableWidthConstraints : self.uniformWidthConstraints)];
    
    if (animated) {
        [UIView animateWithDuration:1.0f animations:^{ // http://stackoverflow.com/questions/12926566/are-nslayoutconstraints-animatable
            [self.view layoutIfNeeded];
        }];
    }
}

/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 */

@end
