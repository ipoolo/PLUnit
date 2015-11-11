//
//  UIView+destroyView.h
//  PLUnit
//
//  Created by liu poolo on 15/7/16.
//  Copyright (c) 2015年 liu poolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (destroyView)

+(void)destroyView:(UIView **) viewNeedDestroy;

@end
