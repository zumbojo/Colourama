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
    [self createContentPages];
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

- (void) createContentPages
{
    NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
    for (int i = 1; i < 11; i++)
    {
        [pageStrings addObject:[self brandNewPaletteViewController]];
    }
    self.contentControllers = [[NSArray alloc] initWithArray:pageStrings];
}

- (CLPaletteViewController *)brandNewPaletteViewController {
    CLPaletteViewController *pvc = [[CLPaletteViewController alloc] initWithPalette:[self samplePalette]];
    pvc.view.bounds = self.view.bounds;
    return pvc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Test Data

- (CLPalette *)samplePalette {
    // "cheer up emo kid"
    // http://www.colourlovers.com/api/palette/1930&showPaletteWidths=1

    return [CLPalette paletteFromArray:@[
            @[@"556270", [NSNumber numberWithFloat:0.2]],
            @[@"4ECDC4", [NSNumber numberWithFloat:0.2]],
            @[@"C7F464", [NSNumber numberWithFloat:0.2]],
            @[@"FF6B6B", [NSNumber numberWithFloat:0.2]],
            @[@"C44D58", [NSNumber numberWithFloat:0.2]]
            ]];
    
//    // "cheer up emo kid"
//    // http://www.colourlovers.com/api/palette/1930&showPaletteWidths=1
//    
//    NSMutableArray *slats = [[NSMutableArray alloc] init];
//    
//    for (NSString *hex in @[@"556270", @"4ECDC4", @"C7F464", @"FF6B6B", @"C44D58"]) {
//        CLSlat *slat = [[CLSlat alloc] init];
//        slat.color = UIColorFromRGBString(hex);
//        slat.width = 0.2f;
//        [slats addObject:slat];
//    }
//    
//    CLPalette *palette = [[CLPalette alloc] init];
//    palette.slats = slats;
//    return palette;
}

@end
