//
//  PLPageScrollView.h
//  PLPageScrollView
//
//  Created by liu poolo on 14/12/14.
//  Copyright (c) 2014年 liu poolo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PLPageScrollViewDelegate;

@interface PLPageScrollView : UIView<UIScrollViewDelegate>

@property (weak, nonatomic) id<PLPageScrollViewDelegate> delegate;

+(instancetype)pageScrollViewHelpPageMaxNum:(int) maxNum prefixFileStr:(NSString* )prefixName;
+(instancetype)pageScrollViewPageMaxNum:(int) maxNum prefixFileStr:(NSString* )prefixName coverViewAlpha:(float)alpha;
+(instancetype)pageScrollViewShowImageNames:(NSArray *)nameArray;
+(instancetype)pageScrollViewShowImageNames:(NSArray *)nameArray coverViewAlpha:(float)alpha;
+(instancetype)pageScrollViewShowImageObjects:(NSArray *)imageArray;
+(instancetype)pageScrollViewShowImageObjects:(NSArray *)imageArray coverViewAlpha:(float)alpha;
-(void)setImage:(UIImage *)image inPageIndex:(int) index;
-(void)configInitPage;// use in viewDidAppear  constraint 和 setOffset放到一起会导致无效果(constraints导致的界面变化会讲offset再度赋0)

@end


@protocol PLPageScrollViewDelegate <NSObject>

@optional
-(void)pageScrollViewTappedWithSender:(UIImageView *)sender pageIndex:(int)index;

@end