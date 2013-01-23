//
//  KLPageViewController.h
//  LoveLetter
//
//  Created by user on 1/22/13.
//  Copyright (c) 2013 Kevin Lawson. All rights reserved.
//

// This is a custom subclass of UIPageViewController that I created to add additional transitions (like fade) while also keeping UIPageViewController's nice API and OOTB transitions (UIPageViewControllerTransitionStylePageCurl, UIPageViewControllerTransitionStyleScroll).

// Here is how this subclass came to be:
// http://developer.apple.com/library/ios/#documentation/uikit/reference/UIPageViewControllerClassReferenceClassRef/UIPageViewControllerClassReference.html
// "This class is generally used as-is but may be subclassed in iOS 6 and later."
// WHOOO-HOO-HOO-HOO-HOO-HOO! http://www.youtube.com/watch?v=w5MfDn_27X0

#import <UIKit/UIKit.h>

@interface KLPageViewController : UIPageViewController

@end
