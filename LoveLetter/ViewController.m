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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    CLPaletteView *pv = [[CLPaletteView alloc] initWithFrame:self.view.frame palette:[self samplePalette]];
//    [self.view addSubview:pv];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIPageViewControllerDataSource
// based on http://www.techotopia.com/index.php/An_Example_iOS_5_iPhone_UIPageViewController_Application

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return [self brandNewPaletteViewController];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return [self brandNewPaletteViewController];
}

- (CLPaletteViewController *)brandNewPaletteViewController {
    CLPaletteViewController *pvc = [[CLPaletteViewController alloc] init];
    pvc.view.bounds = self.view.bounds;
    return pvc;
}

#pragma mark -
#pragma mark Test Data

- (CLPalette *)samplePalette {
    // "cheer up emo kid"
    // http://www.colourlovers.com/api/palette/1930&showPaletteWidths=1
    
    NSMutableArray *slats = [[NSMutableArray alloc] init];
    
    for (NSString *hex in @[@"556270", @"4ECDC4", @"C7F464", @"FF6B6B", @"C44D58"]) {
        CLSlat *slat = [[CLSlat alloc] init];
        slat.color = UIColorFromRGBString(hex);
        slat.width = 0.2f;
        [slats addObject:slat];
    }
    
    CLPalette *palette = [[CLPalette alloc] init];
    palette.slats = slats;
    return palette;
}

@end
