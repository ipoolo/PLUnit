//
//  UIView+destroyView.m
//  PLUnit
//
//  Created by liu poolo on 15/7/16.
//  Copyright (c) 2015年 liu poolo. All rights reserved.
//

#import "UIView+destroyView.h"

@implementation UIView (destroyView)

+(void)destroyView:(UIView **) viewNeedDestroy{
    [*viewNeedDestroy removeFromSuperview];
    *viewNeedDestroy = nil;
}
@end
