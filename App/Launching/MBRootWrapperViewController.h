/*
 MBRootWrapperViewController
 
 Copyright © 2018 RFUI.
 Copyright © 2014-2017 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */
#import <RFKit/RFRuntime.h>

/**
 整个应用的根 vc，除了是主导航的容器外，还承担了很多其他功能
 
 - 启动图的显示管理
 - 管理应用级别的提示，各种气泡，教程提示
 */
@interface MBRootWrapperViewController : UIViewController

+ (null_unspecified instancetype)globalController;

@end
