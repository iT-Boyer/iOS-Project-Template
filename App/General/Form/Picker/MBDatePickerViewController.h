//
//  MBDatePickerViewController.h
//  Feel
//
//  Created by BB9z on 12/10/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "CommonUI.h"
#import "MBModalPresentSegue.h"


/**
 时间选择弹窗，使用 UIDatePicker
 
 备忘：使用实例的 - presentFromViewController:animated:completion: 方法弹出
 */
@interface MBDatePickerViewController : MBModalPresentViewController
@property (nonatomic, nullable, weak) IBOutlet UIDatePicker *datePicker;

#pragma mark - 设置

/// 调用后清除
@property (nonatomic, nullable, copy) void (^datePickerConfiguration)(UIDatePicker *__nonnull datePicker);

/// 选择结果的回调
@property (nonatomic, nullable, copy) void (^didEndSelection)(UIDatePicker *__nonnull datePicker, BOOL canceled);

@end
