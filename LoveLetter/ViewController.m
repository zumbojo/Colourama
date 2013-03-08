//
//  ViewController.m
//  LoveLetter
//
//  Created by user on 1/18/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//


#import "ViewController.h"
#import "CLColor.h"
#import "CLColorViewController.h"
#import "CLPaletteViewController.h"
#import "CLPatternViewController.h"
#import "CLPalette.h"
#import "CLPattern.h"
#import "NSMutableArray_Shuffling.h"
#import "OnlyPortraitNavigationController.h"
#import <QuartzCore/QuartzCore.h>

#define PAGES_TO_KEEP 100 // once we hit this many pages, clean out all but the N most recent pages

@interface ViewController ()

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *contentControllers;

@property (nonatomic) NSTimer *controlVisibilityTimer; // for fading out buttons after a nice delay
@property (nonatomic) NSTimer *fadeToNextPageTimer;
@property (nonatomic) UIViewController *pendingPage; // for keeping track of the current page in UIPageViewController (see UIPageViewControllerDelegate method comments)
@property (nonatomic) UIViewController *currentPage; // ditto

@property (nonatomic) UILabel *loadingLabel;
@property (nonatomic) UIActivityIndicatorView *initialLoadingSpinner;
@property (nonatomic) UIView *menuView;
@property (nonatomic) UIButton *shareButton;
@property (nonatomic) UIButton *settingsButton;
@property (nonatomic) UIActionSheet *shareMenu;
@property (nonatomic) UIPopoverController *settingsPopover;
@property (nonatomic) SettingsViewController *settingsViewController;
@property (nonatomic) UIAlertView *networkAlertView;

@property (nonatomic) BOOL fetchInProgress;

@end

@implementation ViewController

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadBackgroundImage];
    [self showLoadingLabel];

    
//    self.settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil delegate:self];
//
//    self.fetchInProgress = NO;
//    [self checkAndFetchAndClean];
}

- (void)loadBackgroundImage {
    // Detect iPhone 5: http://stackoverflow.com/a/12890447/103058
    // Detect Retina: http://stackoverflow.com/questions/3504173/detect-retina-display
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if ([[UIScreen mainScreen] bounds].size.height == 568) { // iPhone 5 (and probably future widescreen devices)
            self.backgroundImageView.image = [UIImage imageNamed:@"1136x1136"];
        }
        else {
            self.backgroundImageView.image = [UIScreen mainScreen].scale == 2.0 ? [UIImage imageNamed:@"960x960"] : [UIImage imageNamed:@"480x480"];
        }
    }
    else {
        self.backgroundImageView.image = [UIScreen mainScreen].scale == 2.0 ? [UIImage imageNamed:@"2048x2048"] : [UIImage imageNamed:@"1024x1024"];
    }
}

- (void)showLoadingLabel {
    self.loadingLabel = [[UILabel alloc] init];
    self.loadingLabel.text = @"Loading pretty things...";
    self.loadingLabel.textColor = UIColorFromRGBString(@"DDDDDD");
    self.loadingLabel.backgroundColor = [UIColor clearColor];
    // shadow from http://stackoverflow.com/a/4748311/103058
    self.loadingLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.loadingLabel.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.loadingLabel.layer.shadowRadius = 1.0;
    self.loadingLabel.layer.shadowOpacity = 0.5;
    self.loadingLabel.layer.masksToBounds = NO;
    self.loadingLabel.alpha = 0;
    [self.view addSubview:self.loadingLabel];
    
    // offset from center contstraints from http://stackoverflow.com/a/14722308/103058
    [self.loadingLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:40]]; // a few points off of the vertical center
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]]; // horizontal center
    
    // a spinner, too.  why not?:
    self.initialLoadingSpinner = [[UIActivityIndicatorView alloc] init];
    self.initialLoadingSpinner.color = UIColorFromRGBString(@"DDDDDD");
    self.initialLoadingSpinner.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.initialLoadingSpinner.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.initialLoadingSpinner.layer.shadowRadius = 1.0;
    self.initialLoadingSpinner.layer.shadowOpacity = 0.5;
    self.initialLoadingSpinner.layer.masksToBounds = NO;
    self.initialLoadingSpinner.alpha = 0;
    [self.view addSubview:self.initialLoadingSpinner];
    
    [self.initialLoadingSpinner setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.initialLoadingSpinner
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.loadingLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:20]]; // below loadingLabel
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.initialLoadingSpinner
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]]; // horizontal center

    [self.initialLoadingSpinner startAnimating];
    
    // fade in the label immediately:
    [UIView animateWithDuration:0.5 animations:^{
        self.loadingLabel.alpha = 1;
    }];
    
    // fade in spinner after a delay:
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            self.initialLoadingSpinner.alpha = 1;
        }];
    });
}

- (void)setupMenuBarAndSpinner {
    // based on byline (addThingLabels: in CLPrettyThingViewController.m)
    
    UIView *menuView = [[UIView alloc] init];
    menuView.translatesAutoresizingMaskIntoConstraints  = NO;
    menuView.backgroundColor = BAR_BACKGROUND_COLOR;
    [self.pageController.view addSubview:menuView];
    self.menuView = menuView;
    
    UIView *menuViewShadow = [[UIView alloc] init];
    menuViewShadow.translatesAutoresizingMaskIntoConstraints = NO;
    menuViewShadow.backgroundColor = BAR_SHADOW_COLOR;
    [menuView addSubview:menuViewShadow];
    
    // buttons
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"gear"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(settingsButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:settingsButton];
    self.settingsButton = settingsButton;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    [shareButton setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:shareButton];
    self.shareButton = shareButton;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(menuView, menuViewShadow, settingsButton, shareButton);

    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[menuViewShadow]-5-[settingsButton]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[menuViewShadow]-5-[shareButton]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"[shareButton]-10-[settingsButton]-5-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[menuViewShadow(%d)][menuView]-%d-|", BAR_SHADOW_HEIGHT, BYLINE_BACKGROUND_HEIGHT]
                                             options:0
                                             metrics:nil
                                               views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:settingsButton attribute:NSLayoutAttributeHeight multiplier:1 constant:6]];
    
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"|[menuView]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"|[menuViewShadow]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view bringSubviewToFront:self.spinner];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    [self hideControlsAfterDelay];
}

- (void)setupPageViewController {
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey:UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    self.pageController.view.frame = self.view.bounds;
    self.pageController.view.alpha = 0;
    
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
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (self.shareMenu && self.shareMenu.visible) {
            [self cancelControlHiding];
            [self showShareMenu];
        }
        
        if (self.settingsPopover && self.settingsPopover.popoverVisible) {
            [self showSettingsPopover];
        }
    }
}

#pragma mark -
#pragma mark API Interaction (CLMothership Interaction)

- (void)checkAndFetchAndClean {
    if ([self fetchIsNeeded]) {
        [self fetchSomePrettyThings];
    }
}

- (BOOL)fetchIsNeeded {
    return (!self.contentControllers
            || self.contentControllers.count == 0
            || ( self.contentControllers.count - [self.contentControllers indexOfObject:self.currentPage] < 5)) // e.g., if count is 30 and index is 25, it's time to fetch more
            && !self.fetchInProgress
            && self.initialSettingsLoadIsComplete;
}

- (void)fetchSomePrettyThings {
    if (self.showColors || self.showPalettes || self.showPatterns) {
        NSMutableArray *classes = [[NSMutableArray alloc] init];
        
        if (self.showColors) { [classes addObject:[CLColor class]]; }
        if (self.showPalettes) { [classes addObject:[CLPalette class]]; }
        if (self.showPatterns) { [classes addObject:[CLPattern class]]; }
        
        self.fetchInProgress = YES;
        [self.spinner startAnimating];
        [[CLMothership sharedInstance] loadPrettyThingsOfClasses:classes withVariety:self.preferredVariety success:^(NSArray *prettyThings) {
            NSLog(@"%d pretty things returned", [prettyThings count]);
            
            if (!prettyThings.count && !self.networkAlertView) {
                // If nothing is returned, throw up a network error UIAlertView, with a retry button that starts a new fetch operation.
                self.networkAlertView = [[UIAlertView alloc] initWithTitle:@"Network error" message:@"Please check your internet connection." delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil];
                [self.networkAlertView show];
            }
            
            BOOL isFirstBatch = !self.contentControllers.count;
            
            if (isFirstBatch) {
                self.contentControllers = [[NSMutableArray alloc] init];
            }
            
            // shuffle, create PVCs, append to self.contentControllers:
            NSMutableArray *shuffled = [[NSMutableArray alloc] initWithArray:prettyThings];
            [shuffled shuffle];
            [self.contentControllers addObjectsFromArray:[self prettyThingViewControllersFromPrettyThings:shuffled]];
            [self.spinner stopAnimating];
            self.fetchInProgress = NO;
            
            if (self.contentControllers.count > PAGES_TO_KEEP) {
                [self clean];
            }
            
            [self applySettingsToAllContentControllers];
            
            if (isFirstBatch && self.contentControllers.count) {
                [self setupPageViewController];
                [self setupMenuBarAndSpinner];
                
                [UIView animateWithDuration:1 animations:^{
                    self.pageController.view.alpha = 1;
                    self.loadingLabel.alpha = 0;
                    self.initialLoadingSpinner.alpha = 0;
                }];
            }
        }];
    }
    else {
        NSLog(@"showColors, showPalettes, and showPatterns are all set to NO.  Double-u tee eff?");
    }
}

- (void)clean {
    NSLog(@"cleaning.  count: %d", self.contentControllers.count);
    
    NSUInteger currentPageIndex = [self.contentControllers indexOfObject:self.currentPage];
    NSInteger cutoffIndex = self.contentControllers.count - PAGES_TO_KEEP;
    
    if (currentPageIndex > cutoffIndex && cutoffIndex > 0) {
        [self.contentControllers removeObjectsInRange:NSMakeRange(0, cutoffIndex)];
    }
    
    NSLog(@"cleaned!  count: %d", self.contentControllers.count);
}

#pragma mark -
#pragma mark Content Controller Creation

- (NSArray *)prettyThingViewControllersFromPrettyThings:(NSArray *)prettyThings {
    NSMutableArray *ptvcs = [[NSMutableArray alloc] init];
    
    for (CLPrettyThing *thing in prettyThings) {
        CLPrettyThingViewController *ptvc;
        
        if ([thing class] == [CLColor class]) {
            ptvc = [[CLColorViewController alloc] initWithColor:(CLColor *)thing];
        }
        else if ([thing class] == [CLPalette class]) {
            ptvc = [[CLPaletteViewController alloc] initWithPalette:(CLPalette *)thing];
        }
        else if ([thing class] == [CLPattern class]) {
            ptvc = [[CLPatternViewController alloc] initWithPattern:(CLPattern *)thing];
        }
        ptvc.view.bounds = self.view.bounds;
        [ptvcs addObject:ptvc];
    }
    
    return [NSArray arrayWithArray:ptvcs];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == self.networkAlertView) {
        [self checkAndFetchAndClean];
        self.networkAlertView = nil;
    }
}

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

- (void)applyBlock:(void (^)(UIViewController* controller))block toAllContentControllersOfClass:(Class)class {
    for (UIViewController *controller in self.contentControllers) {
        if ([controller isKindOfClass:class]) {
            block(controller);
        }
    }
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
    
    //NSLog(@"did trans: %d, current: %p", completed, self.currentPage);
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    //NSLog(@"will trans to: %p", pendingViewControllers[0]);
    self.pendingPage = pendingViewControllers[0];
    [self checkAndFetchAndClean];
}

#pragma mark - 
#pragma mark UI
#pragma mark Buttons

- (IBAction)shareButtonTouched:(id)sender {
    [self cancelControlHiding];
    [self showShareMenu];
}

- (void)showShareMenu {
    // create shareMenu (or hide existing):
    if (self.shareMenu) {
        // dismiss existing shareMenu to prevent multiple from appearing:
        // see http://stackoverflow.com/questions/5448987/ipads-uiactionsheet-showing-multiple-times
        [self.shareMenu dismissWithClickedButtonIndex:-1 animated:NO];
    }
    
    self.shareMenu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
    
    // show shareMenu:
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //[self.shareMenu showFromRect:((UIButton*)sender).frame inView:((UIButton*)sender).superview animated:YES];
        [self.shareMenu showFromRect:self.shareButton.frame inView:self.shareButton.superview animated:YES];
        // http://stackoverflow.com/questions/13710789/uiactionsheet-showfromrect-autorotation
    }
    else {
        [self.shareMenu showInView:self.view];
    }
}

- (IBAction)settingsButtonTouched:(id)sender {
    [self cancelControlHiding];
        
    // show settingsVC:
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self showSettingsPopover];
    }
    else {
        // http://developer.apple.com/library/ios/#featuredarticles/ViewControllerPGforiPhoneOS/ModalViewControllers/ModalViewControllers.html
        OnlyPortraitNavigationController *navController = [[OnlyPortraitNavigationController alloc] initWithRootViewController:self.settingsViewController];
        self.settingsViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                                         style:UIBarButtonItemStylePlain
                                                                                                        target:self
                                                                                                        action:@selector(dismissViewController)];
        self.settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)showSettingsPopover {
    // http://developer.apple.com/library/ios/#documentation/WindowsViews/Conceptual/ViewControllerCatalog/Chapters/Popovers.html

    if (!self.settingsPopover) {
        self.settingsPopover = [[UIPopoverController alloc] initWithContentViewController:self.settingsViewController];
        self.settingsPopover.delegate = self;
        self.settingsPopover.popoverContentSize = self.settingsViewController.view.frame.size;
    }
    
    [self.settingsPopover presentPopoverFromRect:self.settingsButton.frame inView:self.settingsButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)dismissViewController {
    [self hideControlsAfterDelay];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    // for settingsPopover
    [self hideControlsAfterDelay];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:((CLPrettyThingViewController *)self.currentPage).prettyThing.url]; // http://stackoverflow.com/questions/9343443/alertview-open-safari
        // todo: remove cast if self.currentPage is changed to a CLPrettyThingViewController
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // for shareMenu
    // This is shareMenu's counterpart to settingsPopover's popoverControllerDidDismissPopover (because shareMenu is a UIActionSheet called using showFromRect:inView:, not a true popover).
    [self hideControlsAfterDelay];
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
    return self.menuView.alpha == 0;
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
            self.menuView.alpha = alpha;
        }];
    }
    else {
        self.menuView.alpha = alpha;
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

// fancy fade trick:

- (void)fadeToNextPage {
    NSUInteger currentIndex = [self indexOfViewController:self.currentPage];
    UIViewController *fromVC = self.currentPage;
    UIViewController *toVC = [self viewControllerAtIndex:currentIndex + 1];
        
    if (toVC && [fromVC isKindOfClass:[CLPrettyThingViewController class]]) {
        // create a copy of the currently shown pvc, add it to the main VC, then slowly fade it out as the page view controller is instantly manually advanced in the background
        
        CLPrettyThingViewController *ghost = ((CLPrettyThingViewController *)fromVC).ghost;
        [self addChildViewController:ghost];
        [self.view insertSubview:ghost.view belowSubview:self.menuView];
        
        // sneakily push toVC in background:
        __weak ViewController *weakSelf = self; // to address a "Capturing 'self' strongly in this block is likely to lead to a retain cycle" warning
        // http://stackoverflow.com/questions/7853915/how-do-i-avoid-capturing-self-in-blocks-when-implementing-an-api
        // http://stackoverflow.com/questions/4352561/retain-cycle-on-self-with-blocks
        [self.pageController setViewControllers:@[toVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished){
            if (finished) {
                weakSelf.currentPage = toVC;
            }
        }];
        
        // now fade out the ghost
        [UIView animateWithDuration:1
                         animations:^{
                             ghost.view.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [ghost.view removeFromSuperview];
                             [ghost removeFromParentViewController];
                         }];
    }
    
    [self checkAndFetchAndClean];
}

#pragma mark -
#pragma mark SettingsViewControllerDelegate

- (void)setShowColors:(BOOL)showColors {
    _showColors = showColors;
    
    if (!_showColors) {
        [self removeAllFuturePagesOfClass:[CLColorViewController class]];
    }
    
    [self checkAndFetchAndClean];
}

- (void)setShowPalettes:(BOOL)showPalettes {
    _showPalettes = showPalettes;
    
    if (!_showPalettes) {
        [self removeAllFuturePagesOfClass:[CLPaletteViewController class]];
    }
    
    [self checkAndFetchAndClean];
}

- (void)setShowPatterns:(BOOL)showPatterns {
    _showPatterns = showPatterns;
    
    if (!_showPatterns) {
        [self removeAllFuturePagesOfClass:[CLPatternViewController class]];
    }
    
    [self checkAndFetchAndClean];
}

- (void)removeAllFuturePagesOfClass:(Class)class { // helper for the above setters
    NSUInteger currentPageIndex = [self.contentControllers indexOfObject:self.currentPage];
    NSMutableArray *remove = [[NSMutableArray alloc] init];
    
    for (UIViewController *controller in self.contentControllers) {
        NSUInteger controllerIndex = [self.contentControllers indexOfObject:controller];
        if ([controller isKindOfClass:class] && controllerIndex > currentPageIndex + 1) { // add one to skip the next page, just in case a fade is about to occur
            [remove addObject:controller];
        }
    }
    
    [self.contentControllers removeObjectsInArray:remove];
}

- (void)setTransitionDuration:(NSTimeInterval)transitionDuration {
    _transitionDuration = transitionDuration;
    
    if (self.fadeToNextPageTimer) {
        [self.fadeToNextPageTimer invalidate];
        self.fadeToNextPageTimer = nil;
    }
    
    if (transitionDuration) { // transitionDuration = 0 means no transitions, so don't bother setting up a timer.
        self.fadeToNextPageTimer = [NSTimer scheduledTimerWithTimeInterval:_transitionDuration target:self selector:@selector(fadeToNextPage) userInfo:nil repeats:YES];
    }
}

- (void)setShowVariableWidths:(BOOL)showVariableWidths {
    _showVariableWidths = showVariableWidths;
    [self applySettingsToAllContentControllers];
}

- (void)setShowByline:(BOOL)showByline {
    _showByline = showByline;
    [self applySettingsToAllContentControllers];
}

// Helpers:

- (void)applySettingsToAllContentControllers {
    [self applyBlock:^(UIViewController *controller) {
        [(CLPaletteViewController *)controller setShowVariableWidths:self.showVariableWidths animated:YES];
    } toAllContentControllersOfClass:[CLPaletteViewController class]];

    [self applyBlock:^(UIViewController *controller) {
        [(CLPrettyThingViewController *)controller setShowByline:self.showByline animated:YES];
    } toAllContentControllersOfClass:[CLPrettyThingViewController class]];    
}

@end
