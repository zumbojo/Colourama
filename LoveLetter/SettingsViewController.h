//
//  SettingsViewController.h
//  LoveLetter
//
//  Created by user on 2/1/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate

@property (nonatomic) NSTimeInterval *transitionDuration;

@end


@interface SettingsViewController : UIViewController

- (IBAction)testButtonTouched:(id)sender;
- (IBAction)transitionSpeedSliderValueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *transitionSpeedSlider;
@property(weak) id<SettingsViewControllerDelegate> delegate;

@end