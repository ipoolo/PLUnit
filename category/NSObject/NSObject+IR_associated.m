//
//  NSObject+IR_associated.m
//  PLUnit
//
//  Created by liu poolo on 15/7/7.
//  Copyright (c) 2015年 liu poolo. All rights reserved.
//

#import "NSObject+IR_associated.h"
#import <objc/runtime.h>

@implementation NSObject (IR_associated)

- (id)uxy_getAssociatedObjectForKey:(const char *)key
{
    const char * propName = key;
    id currValue = objc_getAssociatedObject( self, propName );
    return currValue;

}

- (id)uxy_retainAssociatedObject:(id)obj forKey:(const char *)key;
{
    const char * propName = key;
    id oldValue = objc_getAssociatedObject( self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    return oldValue;
}

@end



