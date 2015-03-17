//
//  PLWelcomeVC.h
//  PLWelcomeVC
//
//  Created by liu poolo on 14/12/14.
//  Copyright (c) 2014年 liu poolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLWelcomeVC : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *preBt;
@property (weak, nonatomic) IBOutlet UIButton *nextBt;


-(void)configHelpPageMaxNum:(int) maxNum prefixFileStr:(NSString* )prefixName segueIndentity:(NSString*)segueIndentity;
-(void)configHelpPageMaxNum:(int) maxNum prefixFileStr:(NSString* )prefixName segueIndentity:(NSString*)segueIndentity coverViewAlpha:(float)alpha;

@end
