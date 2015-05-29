//
//  PLLVCConverAnimatedDelegate.m
//  PLLVCConverAnimated
//
//  Created by liu poolo on 15/5/29.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import "PLLVCConverAnimatedDelegate.h"
#import "UIView+ScreenShot.h"

@interface PLLVCConverAnimatedDelegate()


@property (nonatomic,assign) CGRect converViewFromFrame;
@property (nonatomic,assign) CGRect converViewToFrame;

@end

@implementation PLLVCConverAnimatedDelegate

-(void)setDestinationViewController:(UIViewController *)destinationViewController{
    
    if(destinationViewController!=_destinationViewController){
        _destinationViewController = destinationViewController;
        [_destinationViewController.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlerPan:)] ];
        self.transitionInteracted = YES;
    }
}

- (void)handlerPan:(UIPanGestureRecognizer *)pan{
    
    CGPoint translation = [pan translationInView:pan.view];
    CGFloat percent = (translation.y/pan.view.bounds.size.height)*1.5;
    percent = fminf(fmaxf(percent, 0),1);
    
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            [self.destinationViewController.navigationController popViewControllerAnimated:YES];
            //            [self.destinationViewController dismissViewControllerAnimated:YES completion:nil];
            
            break;
        case UIGestureRecognizerStateChanged:
            
            [self updateInteractiveTransition:percent];
            break;
        default:
            [self finishInteractiveTransition];
    }
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return self.animationDuration<=0?2.0f:self.animationDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController<PLLVCConverAnimatedProcotol> *fromVC = (UIViewController<PLLVCConverAnimatedProcotol> *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController<PLLVCConverAnimatedProcotol> *toVC = (UIViewController<PLLVCConverAnimatedProcotol> *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = (UIView *)[transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = (UIView *)[transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    UIView *fromConverView = [fromVC converView];
    UIView *toConverView = [toVC converView];
    
    [fromView setNeedsLayout];
    [fromView layoutIfNeeded];
    [toView setNeedsLayout];
    [toView layoutIfNeeded];
    
    UIImageView *intermediaryFromView = [[UIImageView alloc] initWithImage:[fromConverView convertViewToImage]];
    
    
    CGFloat dissmissAlpha = 0.1f;
    CGAffineTransform offScreenBottom = CGAffineTransformMakeTranslation(0, containerView.frame.size.height);
    
    //显示时获取位置 -只去一次 所以这块 from to 是相对 展示那次的
    if(self.isPresenting){
        
        self.converViewFromFrame = [fromConverView.superview convertRect:fromConverView.frame toView:nil];
        self.converViewToFrame = [toConverView.superview convertRect:toConverView.frame toView:nil];
    }
    
    if(self.isPresenting){
        [toView setTransform:offScreenBottom];
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        [containerView addSubview:intermediaryFromView];
        
    }else{
        toView.alpha = dissmissAlpha;
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        [containerView addSubview:intermediaryFromView];
    }
    
    CGRect toConverViewFrame = toConverView.frame;
    toConverView.frame = [intermediaryFromView.superview convertRect:fromConverView.frame toView:toView];
    
    intermediaryFromView.frame = self.isPresenting ? self.converViewFromFrame : self.converViewToFrame;
    
    //转场动画中用中介view 来展示 fromView和toView的都隐藏
    fromConverView.alpha = 0.0f;
    
    intermediaryFromView.alpha = 1.0f;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if(self.isPresenting){
            fromView.alpha = dissmissAlpha;
            [toView setTransform:CGAffineTransformIdentity];
            [intermediaryFromView setFrame:self.converViewToFrame];
        }else{
            toView.alpha = 1.0f;
            [intermediaryFromView setFrame:self.converViewFromFrame];
            [fromView setTransform:offScreenBottom];
        }
        intermediaryFromView.alpha = 0.0f;
        toConverView.frame = toConverViewFrame;
    } completion:^(BOOL finished) {
        
        [intermediaryFromView removeFromSuperview];
        [toConverView setAlpha:1.0f];
        [fromConverView setAlpha:1.0f];
        toView.alpha = 1.0f;
        fromView.alpha = 1.0;
        [toConverView setNeedsLayout];
        [toConverView layoutIfNeeded];
        [transitionContext completeTransition:YES];
        
    }];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.isPresenting = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.isPresenting = NO;
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.transitionInteracted ? self : nil;
}

#pragma mark - navigationVCDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if([fromVC respondsToSelector:@selector(converView)]){
        //navigation模式不同全部都是        self.isPresenting = YES;
        self.isPresenting = YES;
    }else{
        self.isPresenting = NO;
    }
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    // Check if this is for our custom transition
    
    return self.transitionInteracted ? self : nil;
    
}


@end
