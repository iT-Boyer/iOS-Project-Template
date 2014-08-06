
#import "MBTextView.h"
#import "UITextViewDelegateChain.h"
#import "UIKit+App.h"

@implementation MBTextViewBackgroundImageView
RFInitializingRootForUIView

- (void)onInit {
    self.image = [UIImage imageNamed:@"text_field_bg_normal"];
    self.highlightedImage = [UIImage imageNamed:@"text_field_bg_focused"];
}

- (void)afterInit {
}

@end

@interface MBTextView ()
@property (strong, nonatomic) UITextViewDelegateChain *trueDelegate;
@property (strong, nonatomic) UIColor *textColorCopy;
@property (assign, nonatomic) BOOL displayingPlaceHolder;
@end

@implementation MBTextView
RFInitializingRootForUIView

- (void)onInit {
    [super setDelegate:self.trueDelegate];

    if (!self.placeholderTextColor) {
        self.placeholderTextColor = [UIColor globalPlaceholderTextColor];
    }

    self.textColorCopy = self.textColor;
    if (!self.placeholder) {
        self.placeholder = self.text;
        self.displayingPlaceHolder = YES;
    }
}

- (void)afterInit {
}

- (BOOL)becomeFirstResponder {
    self.backgroundImageView.highlighted = YES;
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    self.backgroundImageView.highlighted = NO;
    return [super resignFirstResponder];
}

#pragma mark - Place Holder

- (void)setDisplayingPlaceHolder:(BOOL)displayingPlaceHolder {
    if (_displayingPlaceHolder != displayingPlaceHolder) {
        _displayingPlaceHolder = displayingPlaceHolder;
        if (displayingPlaceHolder) {
            self.text = self.placeholder;
            self.textColor = self.placeholderTextColor;
        }
        else {
            self.text = nil;
            self.textColor = self.textColorCopy;
        }
    }
}

#pragma mark - Delegate

- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    self.trueDelegate.delegate = delegate;
}

- (UITextViewDelegateChain *)trueDelegate {
    if (!_trueDelegate) {
        _trueDelegate = [UITextViewDelegateChain new];

        [_trueDelegate setDidBeginEditing:^(UITextView *textView, id<UITextViewDelegate> delegate) {
            if ([delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
                [delegate textViewDidBeginEditing:textView];
            }
            [(MBTextView *)textView setDisplayingPlaceHolder:NO];
        }];

        [_trueDelegate setDidEndEditing:^(UITextView *textView, id<UITextViewDelegate> delegate) {
            if ([delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
                [delegate textViewDidEndEditing:textView];
            }
            if (!textView.text.length) {
                [(MBTextView *)textView setDisplayingPlaceHolder:YES];
            }
        }];

        [_trueDelegate setShouldChangeTextInRange:^BOOL(UITextView *aTextView, NSRange range, NSString *replacementText, id<UITextViewDelegate> delegate) {
            MBTextView *textView = (id)aTextView;
            _douto(replacementText)
            _douto(NSStringFromRange(range))
            _douto(NSStringFromRange(textView.selectedRange))
            if (textView.singleLineMode && [replacementText containsString:@"\n"]) {
                // Single character input
                if ([replacementText isEqualToString:@"\n"]) {
                    return NO;
                }

                // Paste
                NSString *singleLineString = [replacementText stringByReplacingOccurrencesOfString:@"\n" withString:@""];

                // Check maxLength limit
                if (textView.maxLength
                    && (textView.text.length + singleLineString.length - range.length > textView.maxLength)) {
                    return NO;
                }

                // Replace textView's text
                NSMutableString *updatedText = [[NSMutableString alloc] initWithString:textView.text];
                [updatedText replaceCharactersInRange:textView.selectedRange withString:singleLineString];
                textView.text = updatedText;

                // Move cursor at end of inserted text
                textView.selectedRange = NSMakeRange(range.location + singleLineString.length, 0);
                return NO;
            }

            if (textView.maxLength) {
                // Needs limit length
                if (replacementText.length + textView.text.length - range.length > textView.maxLength) {
                    return NO;
                }
            }

            if ([delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
                return [delegate textView:aTextView shouldChangeTextInRange:range replacementText:replacementText];
            }
            return YES;
        }];
    }
    return _trueDelegate;
}

@end
