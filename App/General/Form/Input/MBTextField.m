
#import "MBTextField.h"
#import "RFDrawImage.h"
#import "UITextFiledDelegateChain.h"

@interface MBTextField ()
@property (strong, nonatomic) UITextFiledDelegateChain *trueDelegate;
@property (nonatomic) BOOL noBorder;
@end

@implementation MBTextField
RFInitializingRootForUIView

+ (void)load {
    [[self appearance] setBackgroundImage:[UIImage imageNamed:@"text_field_bg_normal"]];
    [[self appearance] setBackgroundHighlightedImage:[UIImage imageNamed:@"text_field_bg_focused"]];
}

- (void)onInit {
    // 文字距边框设定
    self.textEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);

    // 获取焦点自动高亮
    // 只在非默认风格下设置背景图
    if (self.borderStyle == UITextBorderStyleNone) {
        self.noBorder = YES;
    }

    if (self.borderStyle == UITextBorderStyleRoundedRect) {
        self.borderStyle = UITextBorderStyleNone;
    }

    [super setDelegate:self.trueDelegate];
}

- (void)afterInit {
    // 修改 place holder 文字样式
    if (self.placeholder) {
        self.placeholder = self.placeholder;
    }

    // 回车切换到下一个输入框或按钮，默认键盘样式
    if (self.nextField && self.returnKeyType == UIReturnKeyDefault) {
        if ([self.nextField isKindOfClass:[UITextField class]] || [self.nextField isKindOfClass:[UITextView class]]) {
            self.returnKeyType = UIReturnKeyNext;
        }
        else {
            self.returnKeyType = UIReturnKeySend;
        }
    }

    if (!self.noBorder) {
        self.disabledBackground = [[UIImage imageNamed:@"text_field_bg_disabled"] resizableImageWithCapInsets:UIEdgeInsetsMakeWithSameMargin(3)];
        self.background = self.isFirstResponder? self.backgroundHighlightedImage : self.backgroundImage;
    }

    [self addTarget:self action:@selector(MBTextField_onTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 修改 place holder 文字样式
- (void)setPlaceholder:(NSString *)placeholder {
    // iOS 6 无效果
    if (self.placeholderTextAttributes) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:self.placeholderTextAttributes];
    }
    else {
        [super setPlaceholder:placeholder];
    }
}

- (void)setPlaceholderTextAttributes:(NSDictionary *)placeholderTextAttributes {
    _placeholderTextAttributes = placeholderTextAttributes;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:self.placeholderTextAttributes];
}

#pragma mark - 修改默认文字框最低高度
- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.height = MAX(size.height, 36);
    return size;
}

#pragma mark - 文字距边框设定
- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, self.textEdgeInsets);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

#pragma mark - 获取焦点自动高亮
- (BOOL)becomeFirstResponder {
    BOOL can = [super becomeFirstResponder];
    if (can) {
        if (!self.noBorder) {
            self.background = self.backgroundHighlightedImage;
            doutp(self.backgroundImage)
        }
    }
    return can;
}

- (BOOL)resignFirstResponder {
    BOOL can = [super resignFirstResponder];
    if (can) {
        if (!self.noBorder) {
            self.background = self.backgroundImage;
        }
    }
    return can;
}

#pragma mark - 文本长度限制

- (void)MBTextField_onTextFieldChanged:(UITextField *)textField {
    if (!self.maxLength) return;

    // Skip multistage text input
    if (textField.markedTextRange) return;

    NSString *text = textField.text;
    NSInteger maxLegnth = self.maxLength;
    if (text.length > maxLegnth) {
        NSRange rangeIndex = [text rangeOfComposedCharacterSequenceAtIndex:maxLegnth];
        if (rangeIndex.length == 1) {
            textField.text = [text substringToIndex:maxLegnth];
        }
        else {
            NSRange rangeRange = [text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLegnth)];
            textField.text = [text substringWithRange:rangeRange];
        }
    }
}

- (BOOL (^)(UITextField *, NSRange, NSString *, id))MBTextField_shouldChangeCharacters {
    return ^BOOL(UITextField *aTextField, NSRange inRange, NSString *replacementString, id<UITextFieldDelegate> delegate) {
        MBTextField *textField = (id)aTextField;

        if (textField.maxLength) {
            // Needs limit length, skip multistage text input
            if (!inRange.length
                && !textField.markedTextRange) {
                if (replacementString.length + textField.text.length > textField.maxLength) {
                    return NO;
                }
            }
        }

        if ([delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            return [delegate textField:aTextField shouldChangeCharactersInRange:inRange replacementString:replacementString];
        }
        return YES;
    };
}

#pragma mark - Delegate

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    if (delegate != self.trueDelegate) {
        self.trueDelegate.delegate = delegate;
        self.delegate = self.trueDelegate;
    }
}

- (UITextFiledDelegateChain *)trueDelegate {
    if (!_trueDelegate) {
        _trueDelegate = [UITextFiledDelegateChain new];
        [_trueDelegate setShouldReturn:^BOOL(UITextField *aTextField, id<UITextFieldDelegate> delegate) {
            MBTextField *textField = (id)aTextField;
            if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
                if (![delegate textFieldShouldReturn:textField]) {
                    return NO;
                }
            }
            if (![textField isKindOfClass:[MBTextField class]]) return YES;

            if ([textField.nextField isKindOfClass:[UITextField class]]
                || [textField.nextField isKindOfClass:[UITextView class]]) {
                [textField.nextField becomeFirstResponder];
            }
            if ([textField.nextField isKindOfClass:[UIControl class]]) {
                [(UIControl *)textField.nextField sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            return YES;
        }];

        [_trueDelegate setShouldChangeCharacters:self.MBTextField_shouldChangeCharacters];
    }
    return _trueDelegate;
}
@end
