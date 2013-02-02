//
//  SettingsViewController.h
//  LoveLetter
//
//  Created by user on 2/1/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate

@end



@interface SettingsViewController : UIViewController

- (IBAction)testButtonTouched:(id)sender;

@property(weak) id<SettingsViewControllerDelegate> delegate;

@end