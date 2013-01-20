//
//  ViewController.m
//  LoveLetter
//
//  Created by user on 1/18/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//


#import "ViewController.h"
#import "CLPaletteViewController.h"
#import "CLPalette.h"

@interface ViewController ()

@end

@implementation ViewController

- (CLPaletteViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.contentControllers count] == 0) ||
        (index >= [self.contentControllers count])) {
        return nil;
    }
    return [self.contentControllers objectAtIndex:index];
}

- (NSUInteger)indexOfViewController:(CLPaletteViewController *)viewController
{
    return [self.contentControllers indexOfObject:viewController];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:
                        (CLPaletteViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:
                        (CLPaletteViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.contentControllers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateContentControllers];
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey:UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    CLPaletteViewController *initialViewController =
    [self viewControllerAtIndex:0];
    NSArray *viewControllers =
    [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

- (void)populateContentControllers
{
    NSMutableArray *pvcs = [[NSMutableArray alloc] init];
    
    for (CLPalette *palette in [self samplePalettes]) {
        CLPaletteViewController *pvc = [[CLPaletteViewController alloc] initWithPalette:palette];
        pvc.view.bounds = self.view.bounds;
        [pvcs addObject:pvc];
    }
    
    self.contentControllers = [NSArray arrayWithArray:pvcs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Test Data

- (NSArray *)samplePalettes {
    return @[
    // "Terra?"
    // http://www.colourlovers.com/api/palette/292482&showPaletteWidths=1
    [CLPalette paletteFromArray:@[
     @[@"E8DDCB", [NSNumber numberWithFloat:0.05]],
     @[@"CDB380", [NSNumber numberWithFloat:0.06]],
     @[@"036564", [NSNumber numberWithFloat:0.06]],
     @[@"033649", [NSNumber numberWithFloat:0.14]],
     @[@"031634", [NSNumber numberWithFloat:0.69]]
     ]],
    
    // "cheer up emo kid"
    // http://www.colourlovers.com/api/palette/1930&showPaletteWidths=1
    [CLPalette paletteFromArray:@[
     @[@"556270", [NSNumber numberWithFloat:0.2]],
     @[@"4ECDC4", [NSNumber numberWithFloat:0.2]],
     @[@"C7F464", [NSNumber numberWithFloat:0.2]],
     @[@"FF6B6B", [NSNumber numberWithFloat:0.2]],
     @[@"C44D58", [NSNumber numberWithFloat:0.2]]
     ]],

    // "Metro"
    // http://www.colourlovers.com/api/palette/1&showPaletteWidths=1
    [CLPalette paletteFromArray:@[
     @[@"515151", [NSNumber numberWithFloat:0.25]],
     @[@"FFFFFF", [NSNumber numberWithFloat:0.25]],
     @[@"00B4FF", [NSNumber numberWithFloat:0.25]],
     @[@"EEEEEE", [NSNumber numberWithFloat:0.25]]
     ]],
    ];
}

@end
