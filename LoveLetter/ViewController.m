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

#define PAGES_TO_KEEP 100 // once we hit this many pages, clean out all but the N most recent pages

@interface ViewController ()

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *contentControllers;

@property (nonatomic) NSTimer *controlVisibilityTimer; // for fading out buttons after a nice delay
@property (nonatomic) NSTimer *fadeToNextPageTimer;
@property (nonatomic) UIViewController *pendingPage; // for keeping track of the current page in UIPageViewController (see UIPageViewControllerDelegate method comments)
@property (nonatomic) UIViewController *currentPage; // ditto

@property (nonatomic) UIActionSheet *shareMenu;
@property (nonatomic) UIPopoverController *settingsPopover;
@property (nonatomic) SettingsViewController *settingsViewController;

@property (nonatomic) BOOL fetchInProgress;

@end

@implementation ViewController

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil delegate:self];
    
    [self populateContentControllers];
    
    [self setupPageViewController];
    
    [self setupMenuBarAndSpinner];

    self.fetchInProgress = NO;
    [self checkAndFetchAndClean];
}

- (void)setupMenuBarAndSpinner {
    
    // todo: create a menu bar, like the byline bar, BYLINE_BAR_HEIGHT from the bottom of the screen
    // todo: create new settingsButton and shareButtons
    // todo: make settingsButton and shareButtons subviews of this bar
    // todo: handle fading this bar
    
    [self.view bringSubviewToFront:self.spinner];
    [self.view bringSubviewToFront:self.settingsButton];
    [self.view bringSubviewToFront:self.shareButton];
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
            
            // shuffle, create PVCs, append to self.contentControllers:
            NSMutableArray *shuffled = [[NSMutableArray alloc] initWithArray:prettyThings];
            [shuffled shuffle];
            [self.contentControllers addObjectsFromArray:[self prettyThingViewControllersFromPrettyThings:shuffled]];
            [self.spinner stopAnimating];
            self.fetchInProgress = NO;
            
            if (self.contentControllers.count > PAGES_TO_KEEP) {
                [self clean];
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

- (void)populateContentControllers
{
    NSMutableArray *pvcs = [[NSMutableArray alloc] init];
    
    [pvcs addObjectsFromArray:[self prettyThingViewControllersFromPrettyThings:[self samplePalettes]]];
    
    self.contentControllers = pvcs;
}

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
    [self hideControlsAfterDelay]; // reset the hide timer (so touching the buttons keep them shown)

    // create shareMenu (or hide existing):
    if (self.shareMenu) {
        // dismiss existing shareMenu to prevent multiple from appearing:
        // see http://stackoverflow.com/questions/5448987/ipads-uiactionsheet-showing-multiple-times
        [self.shareMenu dismissWithClickedButtonIndex:-1 animated:NO];
    }
    else {
        self.shareMenu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
    }
    
    // show shareMenu:
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.shareMenu showFromRect:((UIButton*)sender).frame inView:((UIButton*)sender).superview animated:YES];
        // http://stackoverflow.com/questions/13710789/uiactionsheet-showfromrect-autorotation
    }
    else {
        [self.shareMenu showInView:self.view];
    }
}

- (IBAction)settingsButtonTouched:(id)sender {
    [self hideControlsAfterDelay]; // reset the hide timer (so touching the buttons keep them shown)
        
    // show settingsVC:
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // http://developer.apple.com/library/ios/#documentation/WindowsViews/Conceptual/ViewControllerCatalog/Chapters/Popovers.html
        self.settingsPopover = [[UIPopoverController alloc] initWithContentViewController:self.settingsViewController];
        self.settingsPopover.popoverContentSize = self.settingsViewController.view.frame.size;
        [self.settingsPopover presentPopoverFromRect:((UIButton*)sender).frame inView:((UIButton*)sender).superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else {
        // http://developer.apple.com/library/ios/#featuredarticles/ViewControllerPGforiPhoneOS/ModalViewControllers/ModalViewControllers.html
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
        self.settingsViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                                         style:UIBarButtonItemStylePlain
                                                                                                        target:self
                                                                                                        action:@selector(dismissViewController)];
        self.settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)dismissViewController {
    [self hideControlsAfterDelay];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:((CLPrettyThingViewController *)self.currentPage).prettyThing.url]; // http://stackoverflow.com/questions/9343443/alertview-open-safari
        // todo: remove cast if self.currentPage is changed to a CLPrettyThingViewController
    }
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
            self.shareButton.alpha = alpha;
            self.settingsButton.alpha = alpha;
        }];
    }
    else {
        self.shareButton.alpha = alpha;
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

// fancy fade trick:

- (void)fadeToNextPage {
    NSUInteger currentIndex = [self indexOfViewController:self.currentPage];
    UIViewController *fromVC = self.currentPage;
    UIViewController *toVC = [self viewControllerAtIndex:currentIndex + 1];
        
    if (toVC && [fromVC isKindOfClass:[CLPrettyThingViewController class]]) {
        // create a copy of the currently shown pvc, add it to the main VC, then slowly fade it out as the page view controller is instantly manually advanced in the background
        
        CLPrettyThingViewController *ghost = ((CLPrettyThingViewController *)fromVC).ghost;
        [self addChildViewController:ghost];
        [self.view insertSubview:ghost.view belowSubview:self.settingsButton];
        
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
    [self applyBlock:^(UIViewController *controller) {
        [(CLPaletteViewController *)controller setShowVariableWidths:showVariableWidths animated:YES];
    } toAllContentControllersOfClass:[CLPaletteViewController class]];
}

- (void)setShowByline:(BOOL)showByline {
    [self applyBlock:^(UIViewController *controller) {
        [(CLPrettyThingViewController *)controller setShowByline:showByline animated:YES];
    } toAllContentControllersOfClass:[CLPrettyThingViewController class]];
}

#pragma mark -
#pragma mark Test Methods

- (void)toggleFadeToNextPageTimer {
    if (!self.fadeToNextPageTimer) {
        self.fadeToNextPageTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(fadeToNextPage) userInfo:nil repeats:YES];
    }
    else {
        [self.fadeToNextPageTimer invalidate];
        self.fadeToNextPageTimer = nil;
    }
}

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
