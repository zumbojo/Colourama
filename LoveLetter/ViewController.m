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
#import "CLMothership.h"

@interface ViewController ()

@property (nonatomic) NSTimer *controlVisibilityTimer;
@property (nonatomic) UIViewController *pendingPage; // for testing
@property (nonatomic) UIViewController *currentPage; // for testing

@end

@implementation ViewController

#pragma mark -
#pragma mark UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.contentControllers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

// Helpers:

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.contentControllers count] == 0) ||
        (index >= [self.contentControllers count])) {
        return nil;
    }
    return [self.contentControllers objectAtIndex:index];
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
    return [self.contentControllers indexOfObject:viewController];
}


#pragma mark -
#pragma mark UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    // no easy way to get the current page from UIPageViewController; it must be done manually:
    // http://stackoverflow.com/questions/8400870/uipageviewcontroller-return-the-current-visible-view
    
    if (completed) {
        self.currentPage = self.pendingPage;
    }
    else {
        self.pendingPage = nil;
    }
    
    NSLog(@"did trans: %d, current: %p", completed, self.currentPage);
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    NSLog(@"will trans to: %p", pendingViewControllers[0]);
    self.pendingPage = pendingViewControllers[0];
}

#pragma mark -

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
    
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    UIViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers =
    [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    self.currentPage = viewControllers[0];
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.view bringSubviewToFront:self.settingsButton];
    [self.view bringSubviewToFront:self.testButton];
    [self.pageController didMoveToParentViewController:self];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    [self hideControlsAfterDelay];
    
    // request a handful of new palettes:
    [[CLMothership sharedInstance] loadPalettesOfType:ColourPaletteTypeNew success:^(NSArray *palettes) {
        [self.contentControllers addObjectsFromArray:[self paletteViewControllersFromPalettes:palettes]];
        NSLog(@"palettes loaded, added to contentControllers");
    }];
}

- (void)populateContentControllers
{
    NSMutableArray *pvcs = [[NSMutableArray alloc] init];
    
    [pvcs addObjectsFromArray:[self paletteViewControllersFromPalettes:[self samplePalettes]]];
    
    self.contentControllers = pvcs;
}

- (NSArray *)paletteViewControllersFromPalettes:(NSArray *)palettes {
    NSMutableArray *pvcs = [[NSMutableArray alloc] init];
    
    for (CLPalette *palette in palettes) {
        CLPaletteViewController *pvc = [[CLPaletteViewController alloc] initWithPalette:palette];
        pvc.view.bounds = self.view.bounds;
        [pvcs addObject:pvc];
    }
    
    return [NSArray arrayWithArray:pvcs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma mark UI
#pragma mark Buttons

- (IBAction)testButtonTouched:(id)sender {
    NSLog(@"testButtonTouched");

    // manually push next VC, as a test of setViewControllers:direction:animated:completion:
    
    NSUInteger currentIndex = [self indexOfViewController:self.currentPage];
    UIViewController *nextVC = [self viewControllerAtIndex:currentIndex + 1];
    [self.pageController setViewControllers:@[nextVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    
    
//    [[CLMothership sharedInstance] loadPalettesOfType:ColourPaletteTypeNew success:^(NSArray *palettes) {
//        [self.contentControllers addObjectsFromArray:[self paletteViewControllersFromPalettes:palettes]];
//        NSLog(@"palettes loaded, added to contentControllers");
//    }];
    
    
    // toggle variable widths for all palette view controllers:
//    for (CLPaletteViewController *pvc in self.contentControllers) {
//        [pvc setShowVariableWidths:!pvc.showVariableWidths animated:YES];
//    }
}

- (IBAction)settingsButtonTouched:(id)sender {
    NSLog(@"settingsButtonTouched");
}

#pragma mark Gestures

- (void)handleTap:(UITapGestureRecognizer *)sender {
    // http://developer.apple.com/library/ios/#documentation/UIKit/Reference/UITapGestureRecognizer_Class/Reference/Reference.html#//apple_ref/occ/cl/UITapGestureRecognizer
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self toggleControls];
    }
}

#pragma mark UI Helpers

// Control hide/show logic from MWPhotoBrowser.

- (BOOL)controlsAreHidden {
    return self.settingsButton.alpha == 0;
}

- (void)hideControls {
    [self setControlsHidden:YES animated:YES permanent:NO];
}

- (void)toggleControls {
    [self setControlsHidden:![self controlsAreHidden] animated:YES permanent:NO];
}

- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated permanent:(BOOL)permanent {
    [self cancelControlHiding];
    
    CGFloat alpha = hidden ? 0.0f : 1.0f;
    
    if (animated) {
        [UIView animateWithDuration:0.35 animations:^{
            self.testButton.alpha = alpha;
            self.settingsButton.alpha = alpha;
        }];
    }
    else {
        self.testButton.alpha = alpha;
        self.settingsButton.alpha = alpha;
    }
    
    if (!permanent) {
        [self hideControlsAfterDelay];
    }
}

- (void)cancelControlHiding {
	if (self.controlVisibilityTimer) {
		[self.controlVisibilityTimer invalidate];
	}
}

// Enable/disable control visiblity timer
- (void)hideControlsAfterDelay {
	if (![self controlsAreHidden]) {
        [self cancelControlHiding];
		self.controlVisibilityTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
	}
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
    
    // "Ashley's Peanut Cake"
    // http://www.colourlovers.com/api/palette/2646927&showPaletteWidths=1
    [CLPalette paletteFromArray:@[
     @[@"5F5453", [NSNumber numberWithFloat:0.37]],
     @[@"EEB548", [NSNumber numberWithFloat:0.10]],
     @[@"F7C95F", [NSNumber numberWithFloat:0.05]],
     @[@"D5BD95", [NSNumber numberWithFloat:0.03]],
     @[@"6D6379", [NSNumber numberWithFloat:0.45]]
     ]]
    ];    
}

@end
