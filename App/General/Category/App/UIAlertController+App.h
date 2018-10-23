/*
 UIAlertController+App
 
 Copyright © 2018 RFUI.
 https://github.com/BB9z/iOS-Project-Template
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */

#import <UIKit/UIKit.h>

@interface UIAlertController (App)

- (void)addCancelActionWithHandler:(nullable void (^)(UIAlertAction *__nonnull action))handler;

- (void)showWithController:(nullable UIViewController *)viewController animated:(BOOL)flag completion:(nullable void (^)(void))completion;

@end
