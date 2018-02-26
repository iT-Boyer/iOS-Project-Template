//
//  MBObjectiveC.c
//  Feel
//
//  Created by BB9z on 29/10/2016.
//  Copyright © 2016 Beijing ZhiYun ZhiYuan Technology Co., Ltd. All rights reserved.
//

#import "MBObjectiveC.h"

void property_attributesParse(objc_property_t property, const char **name, char *type, SEL *getter, SEL *setter, BOOL *isDynamic) {
    const char *propertyName = property_getName(property);
    const char *propertyAttributes = property_getAttributes(property);
    if (name) {
        *name = propertyName;
    }

    if (type) {
        *type = propertyAttributes[1];
    }

    if (getter) {
        char *getterStr = strstr(propertyAttributes, ",G");
        if (getterStr) {
            getterStr = strdup(getterStr + 2);
            getterStr = strsep(&getterStr, ",");
        }
        else {
            getterStr = strdup(propertyName);
        }
        *getter = sel_registerName(getterStr);
        free(getterStr);
    }

    if (setter) {
        char *setterStr = strstr(propertyAttributes, ",S");
        if (setterStr) {
            setterStr = strdup(setterStr + 2);
            setterStr = strsep(&setterStr, ",");
        }
        else {
            asprintf(&setterStr, "set%c%s:", toupper(propertyName[0]), propertyName + 1);
        }
        *setter = sel_registerName(setterStr);
        free(setterStr);
    }

    if (isDynamic) {
        char *dynamicToken = strstr(propertyAttributes, ",D");
        *isDynamic = (dynamicToken != NULL);
    }
}
