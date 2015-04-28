//
//  UIScrollView+pageDisplay.h
//  ParkHereCoupon
//
//  Created by liu poolo on 15/4/28.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (pageDisplay)
@property (nonatomic,strong) UIView *pageDisplayView;
@property (nonatomic,strong) UILabel *pageDisplayLabel;
-(void)showPageDisplayWithStr:(NSString *)str;
@end
