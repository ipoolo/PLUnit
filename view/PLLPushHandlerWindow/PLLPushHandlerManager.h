//
//  PHHPushHandlerWindow.h
//  DemoForPHHPushHandlerWindow
//
//  Created by liu poolo on 15/5/24.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLLPushHandlerManager : NSObject


+(instancetype)shareManager;

-(void)showTitle:(NSString *)title body:(NSString *)body coverAlpha:(NSInteger) coverAlpha statusImage:(UIImage *) image;

-(void)setBody:(NSString *) body;

-(void)setTitle:(NSString *) title;

-(void)setStatusImage:(UIImage *) image;

-(void)setCoverAlpha:(NSInteger)coverAlpha;

@end
