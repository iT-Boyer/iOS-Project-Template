/*
 MBMultiLineLabel
 
 Copyright © 2018 RFUI.
 Copyright © 2014, 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 Copyright © 2014 Chinamobo Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */
#import <RFRuntime.h>
#import <RFInitializing.h>

@class MBLayoutConstraint;

// @MBDependency:1
/**
 解决 UILabel Auto Layout 自适应高度的一系列问题
 
 细节
 
 - iOS 9+ 时代仍有使用必要；
 - iOS 8+ 的 table view cell 自动高度，如果有多行 label，仍需要设置为 MBMultiLineLabel；
 - 如果 label 是从 storyboard 中创建的，Auto layout 会按照 storybaord 中定义的宽度计算其尺寸，这意味着当 label 实际尺寸与在 storybaord 中定义的宽度不一致时，计算出来的高度可能会不正确；
 - 为了解决上述问题，需要设置 preferredMaxLayoutWidth。如果手动去设置，应当考虑 label 宽度变化的情形（比如屏幕旋转），会比较麻烦，失去了自动布局的意义；
 - preferredMaxLayoutWidth 设置的问题，我们在 setBounds 中进行了重写，这样就不用重写了，即当 label 尺寸改变时，设置 preferredMaxLayoutWidth 与新宽度一致；
 - 另一种情况是，如果 label 内容为空，自动布局的尺寸会是 0，一方面会重设尺寸导致 preferredMaxLayoutWidth 失效，为此我们重写了 intrinsicContentSize，让 label 的宽度不会自己收缩成 0；
 - 我们还限定了 label 的最低高度，如果不需要这个特性，请修改 minHeight 属性；
 - 这个类不会设置 numberOfLines。
 */
@interface MBMultiLineLabel : UILabel <
    RFInitializing
>

/**
 最低高度，默认 0
 */
@property (nonatomic) IBInspectable CGFloat minHeight;

#pragma mark - 上下方约束控制

/**
 Label 为空时折叠上下约束
 */
@property (nonatomic) IBInspectable BOOL collapseVerticalMarginWhenEmpty;
@property (weak, nonatomic) IBOutlet MBLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet MBLayoutConstraint *bottomMargin;
@end
