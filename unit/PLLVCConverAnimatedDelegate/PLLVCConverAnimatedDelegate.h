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

@end

@interface PLLVCConverAnimatedDelegate : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>
@property (nonatomic,weak) UIViewController *destinationViewController;
@property (nonatomic,assign) BOOL transitionInteracted;
@property (nonatomic,assign) CGFloat animationDuration;
@property (nonatomic,assign) BOOL isPresenting;

@end