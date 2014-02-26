//
//  CLPrettyThingViewController.m
//  LoveLetter
//
//  Created by user on 1/31/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import "CLPrettyThingViewController.h"

@interface CLPrettyThingViewController ()

@end

@implementation CLPrettyThingViewController

- (void)addThingLabels {
    // add the watermark:
    UILabel *watermarkLabel = [[UILabel alloc] init];
    watermarkLabel.translatesAutoresizingMaskIntoConstraints = NO;
    watermarkLabel.textColor = [UIColor purpleColor];
    #warning watermarkLabel is GHASTLY
    watermarkLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:watermarkLabel];
    
    // add the background (with shadow):
    UIView *byLineBackground = [[UIView alloc] init];
    byLineBackground.translatesAutoresizingMaskIntoConstraints = NO;
    byLineBackground.backgroundColor = BAR_BACKGROUND_COLOR;
    [self.view addSubview:byLineBackground];
    self.byLineView = byLineBackground;
    
    UIView *byLineShadow = [[UIView alloc] init];
    byLineShadow.translatesAutoresizingMaskIntoConstraints = NO;
    byLineShadow.backgroundColor = BAR_SHADOW_COLOR;
    [byLineBackground addSubview:byLineShadow];
    
    // add the label:
    UILabel *byLineLabel = [[UILabel alloc] init];
    byLineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    byLineLabel.textColor = BAR_TEXT_AND_ICON_COLOR;
    byLineLabel.backgroundColor = [UIColor clearColor];
    [byLineBackground addSubview:byLineLabel];
    
    if (self.prettyThing.title && self.prettyThing.userName && self.prettyThing.shortPrintableUrl) { // todo: remove this check as soon as bundled palettes are created via bundled JSON
        // fancy attributed text:
        // http://stackoverflow.com/questions/3586871/bold-non-bold-text-in-a-single-uilabel
        const CGFloat fontSize = 15;
        UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
        UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
        
        NSMutableAttributedString *byLineText = [[NSMutableAttributedString alloc] initWithString:self.prettyThing.title attributes:@{NSFontAttributeName : boldFont}];
        [byLineText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" by " attributes:@{NSFontAttributeName : regularFont}]];
        [byLineText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:self.prettyThing.userName attributes:@{NSFontAttributeName : boldFont}]];
        
        byLineLabel.attributedText = byLineText;
        
        NSMutableAttributedString *watermarkText = [[NSMutableAttributedString alloc] initWithAttributedString:byLineText];
        [watermarkText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" - " attributes:@{NSFontAttributeName : regularFont}]];
        [watermarkText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:self.prettyThing.shortPrintableUrl attributes:@{NSFontAttributeName : regularFont}]];
        [watermarkText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" - " attributes:@{NSFontAttributeName : regularFont}]];
        [watermarkText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:APP_SHORT_PRINTABLE_URL attributes:@{NSFontAttributeName : regularFont}]];

        watermarkLabel.attributedText = watermarkText;
    }
    
    // constraints:
    NSDictionary *views = NSDictionaryOfVariableBindings(watermarkLabel, byLineLabel, byLineBackground, byLineShadow);

    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[watermarkLabel]-5-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"[watermarkLabel]-5-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[byLineLabel]-5-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"[byLineLabel]-5-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[byLineShadow(%d)][byLineBackground(%d)]|", BAR_SHADOW_HEIGHT, BYLINE_BACKGROUND_HEIGHT]
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"|[byLineBackground]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"|[byLineShadow]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
}

- (void)setShowByline:(BOOL)show animated:(BOOL)animated {
    _showByline = show;
    
    if (animated) {
        [UIView animateWithDuration:1.0f animations:^{
            self.byLineView.alpha = _showByline ? 1 : 0;
        }];
    }
    else {
        self.byLineView.alpha = _showByline ? 1 : 0;
    }
}

- (void)setShowWatermark:(BOOL)show animated:(BOOL)animated {
    _showWatermark = show;
    
    if (animated) {
        [UIView animateWithDuration:1.0f animations:^{
            self.watermarkView.alpha = _showWatermark ? 1 : 0;
        }];
    }
    else {
        self.watermarkView.alpha = _showWatermark ? 1 : 0;
    }
}

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 */

@end
