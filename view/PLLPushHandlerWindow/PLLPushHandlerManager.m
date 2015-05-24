//
//  PHHPushHandlerWindow.m
//  DemoForPHHPushHandlerWindow
//
//  Created by liu poolo on 15/5/24.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import "PLLPushHandlerManager.h"
@interface PLLPushHandlerManager()
@property (strong, nonatomic) IBOutlet UIWindow *pushWindow;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *pushAlert;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (nonatomic,strong) NSLayoutConstraint *imageContainerHeightConstraint;

@end

@implementation PLLPushHandlerManager

+(instancetype)shareManager{
    static PLLPushHandlerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PLLPushHandlerManager alloc] init];
        [[NSBundle mainBundle] loadNibNamed:@"PLLPushHandlerWindow" owner:manager options:nil];
        manager.imageContainerHeightConstraint = [NSLayoutConstraint constraintWithItem:manager.imageContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:0];
        [manager.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:manager action:@selector(hide)]];
        
        [manager.imageContainerView addConstraint:manager.imageContainerHeightConstraint];
        [manager.imageContainerHeightConstraint setActive:NO];
        
        [[manager.pushAlert layer] setCornerRadius:5.0f];
        [[manager.pushAlert layer] setMasksToBounds:YES];

    });
    return manager;
}

-(void)showTitle:(NSString *)title body:(NSString *)body coverAlpha:(NSInteger) coverAlpha statusImage:(UIImage *) image{
    [self setTitle:title];
    [self setBody:body];
    [self setCoverAlpha:coverAlpha];
    [self setStatusImage:image];
    if(![self isShowing]){
        self.coverView.alpha = 0;
        [self.pushWindow makeKeyAndVisible];
        [UIView animateWithDuration:0.3f animations:^{
            self.coverView.alpha = 1.0f;
        }];
    }
    
}

-(void)hide{
    if([self isShowing]){
        [UIView animateWithDuration:0.3f animations:^{
            self.coverView.alpha = 0.0f;
        }completion:^(BOOL finished) {
            self.pushWindow.hidden = YES;
        }];
    }
    
}

-(void)setBody:(NSString *) body{
    [self.bodyLabel setText:body];
}

-(void)setTitle:(NSString *) title{
    [self.titleLabel setText:title];
}

-(void)setStatusImage:(UIImage *) image{
    if(image){
        if(![self isImageContainerShow]){
            self.imageContainerView.hidden = NO;
            self.imageContainerHeightConstraint.active = NO;
        }
        self.statusImageView.image = image;
    }else{
        self.imageContainerView.hidden = YES;
        self.imageContainerHeightConstraint.active = YES;
        self.statusImageView.image = nil;
    }
}

-(void)setCoverAlpha:(NSInteger)coverAlpha{
    self.coverView.alpha = coverAlpha;
}

#pragma mark - private

-(BOOL)isImageContainerShow{
    if(self.imageContainerView.frame.size.height>0){
        return YES;
    }
    return NO;
}

-(BOOL)isShowing{
    if(self.pushWindow.hidden){
        return NO;
    }
    return YES;
}



@end
