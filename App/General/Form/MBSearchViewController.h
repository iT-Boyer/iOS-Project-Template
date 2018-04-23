/*!
 MBSearchViewController
 
 Copyright © 2018 RFUI.
 https://github.com/RFUI/MBAppKit
 
 Apache License, Version 2.0
 http://www.apache.org/licenses/LICENSE-2.0
 */
#import "Common.h"
#import "MBSearchTextField.h"

/**
 通用沉浸式搜索界面
 
 用来替代 UISearchDisplayController
 */
@interface MBSearchViewController : UIViewController <
    UISearchBarDelegate
>
@property (nonatomic, weak) IBOutlet MBSearchTextField *searchTextField;
@property (nonatomic, weak) IBOutlet UIView *container;
@property IBInspectable BOOL focusSearchBarWhenAppear;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint  *keyboardAdjustLayoutConstraint;

- (IBAction)onCancel:(id)sender;

@end


