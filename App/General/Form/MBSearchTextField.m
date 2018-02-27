//
//  MBSearchTextField.m
//  Feel
//
//  Created by jyq on 16/9/9.
//  Copyright © 2016年 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "MBSearchTextField.h"
#import "UITextFiledDelegateChain.h"
#import "RFTimer.h"
#import "API.h"

@interface MBSearchTextField ()
@property (strong, nonatomic) RFTimer *autoSearchTimer;
@property (strong, nonatomic) UITextFiledDelegateChain *trueDelegate;
@end

@implementation MBSearchTextField
RFInitializingRootForUIView


- (void)onInit {
    self.autoSearchTimeInterval = 0.6;
}

- (void)afterInit {
    [super setDelegate:self.trueDelegate];
    self.returnKeyType = UIReturnKeySearch;
    [self addTarget:self action:@selector(MBTextField_onTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Delegate

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    if (delegate != self.trueDelegate) {
        self.trueDelegate.delegate = delegate;
        self.delegate = self.trueDelegate;
    }
}

- (void)MBTextField_onTextFieldChanged:(UITextField *)textField {    
    if (textField.markedTextRange) return;
    NSString *s = textField.text;
    if (!s.length) {
        return;
    }
    self.autoSearchTimer.suspended = YES;
    RFAssert(self.APIName.length, @"未传入APIName");
    [API.global cancelOperationWithIdentifier:self.APIName];
    self.autoSearchTimer.suspended = NO;
}

- (UITextFiledDelegateChain *)trueDelegate {
    if (!_trueDelegate) {
        _trueDelegate = [UITextFiledDelegateChain new];
        @weakify(self);
        [_trueDelegate setShouldReturn:^BOOL(UITextField *aTextField, id<UITextFieldDelegate> delegate) {
            @strongify(self);
            MBSearchTextField *textField = (id)aTextField;
            if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
                if (![delegate textFieldShouldReturn:textField]) {
                    return NO;
                }
            }
            if (!textField.text.length) {
                return NO;
            }
            [self doSearchforce];
            return YES;
        }];
    }
    return _trueDelegate;
}

#pragma mark 搜索

- (RFTimer *)autoSearchTimer {
    if (!_autoSearchTimer && self.autoSearchTimeInterval > 0) {
        _autoSearchTimer = [RFTimer new];
        _autoSearchTimer.timeInterval = self.autoSearchTimeInterval;
        
        @weakify(self);
        [_autoSearchTimer setFireBlock:^(RFTimer *timer, NSUInteger repeatCount) {
            @strongify(self);
            [self doSearchforce];
        }];
    }
    return _autoSearchTimer;
}

- (void)doSearchforce {
    if ((self.disallowEmptySearch && !self.text.length) || self.text.length < self.autoSearchMinimumLength) {
        return;
    }
    if (self.doSearch) {
        self.doSearch(self.text);
    }
}

@end
