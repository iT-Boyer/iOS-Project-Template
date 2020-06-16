/*
 MBObjectiveC
 
 Objective-C 运行时工具
 
 Copyright © 2018 BB9z.
 Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd.
 https://github.com/BB9z/iOS-Project-Template
 
 The MIT License
 https://opensource.org/licenses/MIT
 */

@import Foundation;
@import ObjectiveC;

// @MBDependency:1
/**
 解析 objc_property_t
 */
void property_attributesParse(objc_property_t property, const char **name, char *type, SEL *getter, SEL *setter, BOOL *isDynamic);
