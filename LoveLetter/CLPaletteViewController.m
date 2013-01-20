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
        
        NSDictionary *views = NSDictionaryOfVariableBindings(slatView);
        
        // vertical is easy:
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[slatView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
        
        // horizontal is a bit more involved:
        
        if (slatView == self.slatViews[0]) { // if first, glue left to superview left
            NSLog(@"first");
            [self.view addConstraints:
             [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[slatView]|"
                                                     options:0
                                                     metrics:nil
                                                       views:views]];
        }
        else { // if not first, glue left to last, set width equal to first
            NSLog(@"not first");
        }
        
        if (slatView == self.slatViews.lastObject) { // if last, glue right to superview right
            NSLog(@"last");
        }
    }
    
    /*
    UIView *one = [[UIView alloc] init];
    one.layer.backgroundColor = ((CLSlat *)self.palette.slats[0]).color.CGColor;
    [one setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:one];
    
    UIView *two = [[UIView alloc] init];
    two.layer.backgroundColor = ((CLSlat *)self.palette.slats[1]).color.CGColor;
    [two setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:two];
    
    //        UIView *three = [[UIView alloc] initWithFrame:CGRectMake(width * 2, 0, width, self.frame.size.height)];
    //        three.layer.backgroundColor = ((CLSlat *)self.palette.slats[2]).color.CGColor;
    //        [self addSubview:three];
    
    // visual format syntax: http://developer.apple.com/library/mac/#documentation/UserExperience/Conceptual/AutolayoutPG/Articles/formatLanguage.html#//apple_ref/doc/uid/TP40010853-CH3-SW1
    
    NSDictionary *views = NSDictionaryOfVariableBindings(one, two);
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[one][two(==one)]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[one]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[two]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
