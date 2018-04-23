//
//  CommonUI.h
//  Feel
//
//  Created by BB9z on 11/29/14.
//  Copyright (c) 2014 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#pragma once

/*!
 常用 UI 组件，正常所有跟 UI 打交道的业务类应该引入这个头文件
 
 下面的组件中应避免引入这个 header 防止循环引入
 */
#import "Common.h"

// AutoLayout 常用类
#import "MBLayoutConstraint.h"
#import "NSLayoutConstraint+RFKit.h"
#import "MBCollapsibleView.h"

// 常用列表类
#import "MBTableViewController.h"
#import "MBTableViewCell.h"
#import "MBTableHeaderFooterView.h"

// 常用结构组织类
#import "RFContainerView.h"
#import "MBStateMachineView.h"

// 常用业务 view
#import "MBVauleLabel.h"
#import "ZYLayoutButton.h"
#import "MBLoadButton.h"
#import "ZYImageView.h"

// 工具类
#import "UIView+RFAnimate.h"
