//  NSMutableArray_Shuffling.h
// from http://stackoverflow.com/a/56656/103058

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#include <Cocoa/Cocoa.h>
#endif

// This category enhances NSMutableArray by providing
// methods to randomly shuffle the elements.
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end