//
//  NSObject+IR_associated.h
//  PLUnit
//
//  Created by liu poolo on 15/7/7.
//  Copyright (c) 2015年 liu poolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IR_associated)
- (id)uxy_getAssociatedObjectForKey:(const char *)key;
- (id)uxy_retainAssociatedObject:(id)obj forKey:(const char *)key;
@end
