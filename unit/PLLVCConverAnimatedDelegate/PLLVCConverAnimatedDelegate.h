//
//  PLLVCConverAnimatedDelegate.h
//  PLLVCConverAnimated
//
//  Created by liu poolo on 15/5/29.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLLVCConverAnimatedProcotol <NSObject>

@required
-(UIView *)converView;
-(BOOL)isConverViewTreeConstraintsWithTopLayoutGuide;
//需要返回 返回的converView是否与 TopLayoutGuide 有约束 间接的也算(只要TopLayoutGuide 变化converView也要变化就算)

@end

@interface PLLVCConverAnimatedDelegate : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>
@property (nonatomic,weak) UIViewController *destinationViewController;
@property (nonatomic,assign) BOOL transitionInteracted;
@property (nonatomic,assign) CGFloat animationDuration;
@property (nonatomic,assign) BOOL isPresenting;
@property (nonatomic,assign) CGFloat percentToPop;
@property (nonatomic,assign) CGFloat percentSpring;

@end
