//
//  UIScrollView+pageDisplay.m
//  ParkHereCoupon
//
//  Created by liu poolo on 15/4/28.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import "UITableView+pageDisplay.h"
#import <objc/runtime.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation UITableView (pageDisplay)

@dynamic pageDisplayView;
@dynamic pageDisplayLabel;

static int kPageDisplayViewKey;
static int kPageDisplayLabelKey;

-(UIView*)pageDisplayView{
    return objc_getAssociatedObject(self, &kPageDisplayViewKey);
}

-(void)setPageDisplayView:(UIView *)pageDisplayView{
    objc_setAssociatedObject(self, &kPageDisplayViewKey, pageDisplayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView*)pageDisplayLabel{
    return objc_getAssociatedObject(self, &kPageDisplayLabelKey);
}

-(void)setPageDisplayLabel:(UILabel *)pageDisplayLabel{
    objc_setAssociatedObject(self, &kPageDisplayLabelKey, pageDisplayLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if(newSuperview&&(self.pageDisplayView==nil||self.pageDisplayLabel==nil)){
        self.pageDisplayView = [[UIView alloc] init];
        [newSuperview addSubview:self.pageDisplayView];
        [self.pageDisplayView setBackgroundColor:[UIColor grayColor]];
        [self.pageDisplayView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.pageDisplayView.layer setCornerRadius:5.0f];
        
        [newSuperview addConstraint:[NSLayoutConstraint constraintWithItem:newSuperview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.pageDisplayView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [newSuperview addConstraint:[NSLayoutConstraint constraintWithItem:self.pageDisplayView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:newSuperview attribute:NSLayoutAttributeBottom multiplier:0.95 constant:0]];
        

        
        self.pageDisplayLabel = [[UILabel alloc] init];
        [self.pageDisplayLabel setTextColor:[UIColor whiteColor]];
        [self.pageDisplayView addSubview:self.pageDisplayLabel];
        [self.pageDisplayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        //configPageDisplayLabel
        UILabel *_pageDisplayLabel = self.pageDisplayLabel;
        NSDictionary *views = NSDictionaryOfVariableBindings(_pageDisplayLabel);
        NSDictionary *metircs = @{@"margin":@(3)};
        [self.pageDisplayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_pageDisplayLabel]-margin-|" options:NSLayoutFormatAlignAllTop metrics:metircs views:views]];
        [self.pageDisplayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_pageDisplayLabel]-margin-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metircs views:views]];
        
        self.pageDisplayView.hidden = YES;

    }
}

-(void)showPageDisplayWithStr:(NSString *)str{
    [self.pageDisplayLabel setText:str];
    [self.superview bringSubviewToFront:self.pageDisplayView];
    self.pageDisplayView.hidden = NO;
    self.pageDisplayView.alpha = 0.0;
    [UIView animateWithDuration:1.5 animations:^{
        self.pageDisplayView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            if(self.pageDisplayView.alpha == 1.0){
                self.pageDisplayView.alpha = 0.0;
            }
        } completion:^(BOOL finished) {

        }];
    }];
}


@end
