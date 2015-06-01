
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
@property (nonatomic,assign) BOOL isDelegateForNavigationPush;
@property (nonatomic,assign) BOOL isDelegateForNavigation;

@end

@implementation PLLVCConverAnimatedDelegate

-(void)setDestinationViewController:(UIViewController *)destinationViewController{
    
    if(destinationViewController!=_destinationViewController){
        _destinationViewController = destinationViewController;
        [_destinationViewController.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlerPan:)] ];
        
    }
}

- (void)handlerPan:(UIPanGestureRecognizer *)pan{
    
    CGPoint translation = [pan translationInView:pan.view];
    CGFloat percent = (translation.y/pan.view.bounds.size.height)*(self.percentSpring?self.percentSpring:1.5);
    percent = fminf(fmaxf(percent, 0),1);
    
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.transitionInteracted = YES;
            [self.destinationViewController.navigationController popViewControllerAnimated:YES];
            [self.destinationViewController dismissViewControllerAnimated:YES completion:nil];
            
            break;
        case UIGestureRecognizerStateChanged:
            
            if(percent<=1){
                [self updateInteractiveTransition:percent];
            }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if(percent>(self.percentToPop?self.percentToPop:0.4)){
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            self.transitionInteracted = NO;
            break;
        default:
            
            break;
            
    }
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return self.animationDuration<=0?2.0f:self.animationDuration;
}

-(UIView *)viewGetTopSuperView:(UIView *)view{
    if(view.superview){
        return [self viewGetTopSuperView:view.superview];
    }else{
        return view;
    }
}

-(CGFloat)totalScorllViewOffset:(UIView *)view{
    if(view.superview){
        return [self totalScorllViewOffset:view.superview]+([view isKindOfClass:[UIScrollView class]]?((UIScrollView *)view).contentOffset.y:0);
    }else{
        return 0;
    }
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController<PLLVCConverAnimatedProcotol> *fromVC = (UIViewController<PLLVCConverAnimatedProcotol> *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController<PLLVCConverAnimatedProcotol> *toVC = (UIViewController<PLLVCConverAnimatedProcotol> *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = (UIView *)[transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = (UIView *)[transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    UIView *fromConverView;
    UIView *toConverView;
    
    if([fromVC respondsToSelector:@selector(converView)]){
        fromConverView = [fromVC converView];
        [fromConverView.superview bringSubviewToFront:fromConverView];
    }else{
        [NSException exceptionWithName:@"CustomError_fromVC_ConverView_invalid" reason:[NSString stringWithFormat:@"%@-fromVC_can't_respondsToSelector_converView",fromVC] userInfo:nil];
    }
    if([toVC respondsToSelector:@selector(converView)]){
        toConverView = [toVC converView];
        [toConverView.superview bringSubviewToFront:toConverView];
    }else{
        [NSException exceptionWithName:@"CustomError_toVC_ConverView_invalid" reason:[NSString stringWithFormat:@"%@-toVC_can't_respondsToSelector_converView",toVC] userInfo:nil];
    }
    //其实只有 能responds才能执行过来...
    
    [fromView setNeedsLayout];
    [fromView layoutIfNeeded];
    [toView setNeedsLayout];
    [toView layoutIfNeeded];
    
    //   TODO:下一行test//
    UIImageView *intermediaryView = [[UIImageView alloc] initWithImage:[fromConverView convertViewToImage]];
    
    
    CGFloat dissmissAlpha = 0.1f;
    CGAffineTransform offScreenBottom = CGAffineTransformMakeTranslation(0, containerView.frame.size.height);
    
    //显示时获取位置 -只去一次 所以这块 from to 是相对 展示那次的
    if(self.isPresenting){
        self.converViewFromFrame = [fromConverView.superview convertRect:fromConverView.frame toView:nil];
        self.converViewToFrame = [toConverView.superview convertRect:toConverView.frame toView:[self viewGetTopSuperView:toConverView]];
        
        if(self.isDelegateForNavigationPush){
            //在最初计算conver的时候 push情况下 toView是没有navigationBar的(UILayoutGuide_top 在界面未移动到y<64(naivgatioNBar高度)之前 是=0的) 所以在ToView还未显示到界面y=0之前计算的conver 是少了这64高度的计算的 所以得减去这64的高度（少算了））
            if([toVC respondsToSelector:@selector(isConverViewTreeConstraintsWithTopLayoutGuide)]&&[toVC isConverViewTreeConstraintsWithTopLayoutGuide]){
                self.converViewToFrame = CGRectOffset(self.converViewToFrame, 0, 64);
            }
            
        }
        
    }
    
    if(self.isPresenting){
        [toView setTransform:offScreenBottom];
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        [containerView addSubview:intermediaryView];
        
    }else{
        toView.alpha = dissmissAlpha;
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        [containerView addSubview:intermediaryView];
    }
    
    CGRect toConverViewFrame = toConverView.frame;
    intermediaryView.frame = self.isPresenting ? self.converViewFromFrame : self.converViewToFrame;
    toConverView.frame = [intermediaryView.superview convertRect:intermediaryView.frame toView:toView];
    
    
    if(self.isDelegateForNavigation){
        
        toConverView.frame = CGRectOffset(toConverView.frame, 0, [self totalScorllViewOffset:toConverView]);
        if([toVC respondsToSelector:@selector(isConverViewTreeConstraintsWithTopLayoutGuide)]&&[toVC isConverViewTreeConstraintsWithTopLayoutGuide]){
            toConverView.frame = CGRectOffset(toConverView.frame, 0, -64);
        }
        
        //在最初计算conver的时候 toView是没有navigationBar的(UILayoutGuide_top 在界面未移动到y<64(naivgatioNBar高度)之前 是=0的) 所以在ToView还未显示到界面y=0之前计算的conver 是少了这64高度的计算的 所以得减去这64的高度（少算了））
        //因为有可能toView位于scrollView之上 因为我们是需要将view转换到 toConverView的坐标系上 那么当外部坐标转换到scrollView 内的时候 需要+ contentoffset.y 用于计算
    }
    
    
    //转场动画中用中介view 来展示 fromView
    
    fromConverView.alpha = 0.0f;
    intermediaryView.alpha = 1.0f;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if(self.isPresenting){
            fromView.alpha = dissmissAlpha;
            [toView setTransform:CGAffineTransformIdentity];
            [intermediaryView setFrame:self.converViewToFrame];
        }else{
            toView.alpha = 1.0f;
            [intermediaryView setFrame:self.converViewFromFrame];
            [fromView setTransform:offScreenBottom];
        }
        intermediaryView.alpha = dissmissAlpha;
        toConverView.frame = toConverViewFrame;
        
    } completion:^(BOOL finished) {
        
        [intermediaryView removeFromSuperview];
        [toConverView setAlpha:1.0f];
        [fromConverView setAlpha:1.0f];
        toView.alpha = 1.0f;
        fromView.alpha = 1.0f;
        [toConverView setNeedsLayout];
        [toConverView layoutIfNeeded];
        if(transitionContext.transitionWasCancelled){
            //cancel
            //将改变的设置回初值位置
            //fromView没改变(因为用了intermediaryView)
            [toView setTransform:CGAffineTransformIdentity];
            toConverView.frame = toConverViewFrame;
            
        }
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
    }];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    if([presented respondsToSelector:@selector(converView)]&&[presenting respondsToSelector:@selector(converView)]){
        self.isPresenting = YES;
        self.isDelegateForNavigation = NO;
        self.isDelegateForNavigationPush = NO;
        return self;
    }else{
        return nil;
    }
    
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    if([dismissed respondsToSelector:@selector(converView)]){
        self.isPresenting = NO;
        self.isDelegateForNavigation = NO;
        self.isDelegateForNavigationPush = NO;
        return self;
    }else{
        return nil;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.transitionInteracted ? self : nil;
}

#pragma mark - navigationVCDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    
    if([fromVC respondsToSelector:@selector(converView)]&&[toVC respondsToSelector:@selector(converView)]){
        //navigation模式不同全部都是        self.isPresenting = YES;
        if(operation==UINavigationControllerOperationPush){
            self.isDelegateForNavigationPush = YES;
        }else{
            self.isDelegateForNavigationPush = NO;
        }
        self.isDelegateForNavigation = YES;
        self.isPresenting = YES;
        return self;
    }else{
        return nil;
    }
    
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    // Check if this is for our custom transition
    
    return self.transitionInteracted ? self : nil;
}


@end
