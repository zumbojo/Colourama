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
    
    
    // add the background (with shadow):
    UIView *byLineBackground = [[UIView alloc] init];
    byLineBackground.translatesAutoresizingMaskIntoConstraints = NO;
    byLineBackground.backgroundColor = UIColorFromRGBString(@"F1F1F1");
    [self.view addSubview:byLineBackground];
    
    UIView *byLineShadow = [[UIView alloc] init];
    byLineShadow.translatesAutoresizingMaskIntoConstraints = NO;
    byLineShadow.backgroundColor = UIColorFromRGBString(@"CCCCCC");
    [self.view addSubview:byLineShadow];
    
    // add the label:
    UILabel *byLineLabel = [[UILabel alloc] init];
    byLineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    byLineLabel.textColor = UIColorFromRGBString(@"808080");
    byLineLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:byLineLabel];
    
    if (self.prettyThing.title && self.prettyThing.userName) { // todo: remove this check as soon as bundled palettes are created via bundled JSON
        // fancy attributed text:
        // http://stackoverflow.com/questions/3586871/bold-non-bold-text-in-a-single-uilabel
        const CGFloat fontSize = 15;
        UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
        UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.prettyThing.title attributes:@{NSFontAttributeName : boldFont}];
        [attributedText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" by " attributes:@{NSFontAttributeName : regularFont}]];
        [attributedText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:self.prettyThing.userName attributes:@{NSFontAttributeName : boldFont}]];
        
        byLineLabel.attributedText = attributedText;
    }
    
    // constraints:
    NSDictionary *views = NSDictionaryOfVariableBindings(byLineLabel, byLineBackground, byLineShadow);
    
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
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[byLineShadow(2)][byLineBackground(25)]|"
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
