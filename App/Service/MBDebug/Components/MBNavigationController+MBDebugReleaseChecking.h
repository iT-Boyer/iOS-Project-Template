/*!
 MBNavigationController ReleaseChecking
 MBDebug
 
 Copyright © 2018 RFUI.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import <MBAppKit/MBNavigationController.h>

#if RFDEBUG

@interface MBNavigationController (MBDebugReleaseChecking)
@end

#endif

@protocol MBDebugNavigationReleaseChecking
@optional
- (BOOL)debugShouldIgnoralCheckReleaseForViewController:(UIViewController *)viewController;
@end

