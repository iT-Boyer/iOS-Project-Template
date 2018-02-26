//
//  MBObjectiveC.h
//  Feel
//
//  Created by BB9z on 29/10/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

@import Foundation;
@import ObjectiveC;

/**
 解析 objc_property_t
 */
void property_attributesParse(objc_property_t property, const char **name, char *type, SEL *getter, SEL *setter, BOOL *isDynamic);
