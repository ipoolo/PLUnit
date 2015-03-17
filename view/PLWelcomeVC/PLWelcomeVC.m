//
//  PLWelcomeVC.m
//  PLWelcomeVC
//
//  Created by liu poolo on 14/12/14.
//  Copyright (c) 2014年 liu poolo. All rights reserved.
//

#import "PLWelcomeVC.h"

@interface PLWelcomeVC ()
@property (nonatomic,copy) NSDictionary *imageViewDic;
@property (nonatomic,copy) NSDictionary *errorKeys;
@property (nonatomic,assign) int currPage;
@property (strong,nonatomic) UIView *splaceHolderView;
@property (strong, nonatomic) UIButton *enterBt;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIView *coverView;
@property (strong,nonatomic) UIPageControl *pageControl;
@property (assign, nonatomic) int helpPageMaxNum;
@property (strong,nonatomic) NSString *prefixName;
@property (strong,nonatomic) NSString *segueIndentity;
@property (assign,nonatomic) float coverViewAlpha;

@end

@implementation PLWelcomeVC


-(void)configHelpPageMaxNum:(int) maxNum prefixFileStr:(NSString* )prefixName segueIndentity:(NSString*)segueIndentity{
    self.helpPageMaxNum = maxNum;
    self.prefixName = prefixName;
    self.segueIndentity = segueIndentity;
    self.coverViewAlpha = 0.7f;
}
-(void)configHelpPageMaxNum:(int) maxNum prefixFileStr:(NSString* )prefixName segueIndentity:(NSString*)segueIndentity coverViewAlpha:(float)alpha{
    [self configHelpPageMaxNum:maxNum prefixFileStr:prefixName segueIndentity:segueIndentity];
    if(alpha>1){
        self.coverViewAlpha = 1.f;
    }else if(alpha<=0){
        self.coverViewAlpha = 0.f;
    }else{
        self.coverViewAlpha = alpha;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self configConstraints];
}

- (void)configView{
    
    //configScrollView
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.scrollView];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    self.scrollView.delegate = self;
    
    //configCoverView
    self.coverView = [[UIView alloc] init];
    [self.coverView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.coverView setBackgroundColor:[UIColor blackColor]];

    [self.coverView setAlpha:_coverViewAlpha];

    [self.view addSubview:self.coverView];
    
    //configPageControl
    self.pageControl = [[UIPageControl alloc] init];
    [self.pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.pageControl];
    
    //goHomeBt
    self.enterBt = [[UIButton alloc] init];
    [self.enterBt setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.enterBt addTarget:self action:@selector(enterBtTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.enterBt setTitle:@"进入" forState:UIControlStateNormal];
    [self.view addSubview:self.enterBt];
    
    NSMutableDictionary *tempMDic = [@{} mutableCopy];
    NSMutableDictionary *tempErrorKeys= [@{} mutableCopy];
    for(int i=1;i<=self.helpPageMaxNum;i++){
        UIImageView* tempImageView = [[UIImageView alloc] init];
        
        [tempImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",_prefixName,i]]];
        [tempImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scrollView addSubview:tempImageView];
        [tempMDic setObject:tempImageView forKey:[NSString stringWithFormat:@"key%d",i]];
        if(!tempImageView.image){
            [tempErrorKeys setObject:[NSNumber numberWithInt:i] forKey:[NSString stringWithFormat:@"key%d",i]];
        }
    }
    self.errorKeys = tempErrorKeys;
    self.imageViewDic = tempMDic;
    self.splaceHolderView = [[UIView alloc] init];
    [self.splaceHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView addSubview:self.splaceHolderView];
    [self.pageControl setNumberOfPages:(self.helpPageMaxNum-self.errorKeys.count)];
    
    
    self.preBt.hidden = YES;
    self.nextBt.hidden = NO;
    self.enterBt.hidden = YES;
    
    [self.preBt addTarget:self action:@selector(preBtTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBt addTarget:self action:@selector(nextBtTapped:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configConstraints{
    NSDictionary* views = NSDictionaryOfVariableBindings(_scrollView,_coverView,_pageControl,_enterBt);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_scrollView]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_coverView]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_pageControl]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_enterBt]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_scrollView]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_coverView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_enterBt attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_coverView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    views = NSDictionaryOfVariableBindings(_splaceHolderView);
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_splaceHolderView]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_splaceHolderView]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.splaceHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1*(self.helpPageMaxNum-self.errorKeys.count) constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.splaceHolderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];

    
    //configImageViews
    
    NSMutableString* horizontalStr = [@"|-0-" mutableCopy];
    for(int i=1;i<=self.helpPageMaxNum;i++){
        if(![self.errorKeys objectForKey:[NSString stringWithFormat:@"key%d",i]]){
            [horizontalStr appendFormat:@"[key%d(==key1)]-0-",i];
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[key%d]-0-|",i] options:NSLayoutFormatDirectionLeftToRight metrics:nil views:self.imageViewDic]];
        }
    }
    [horizontalStr appendFormat:@"|"];
    if([horizontalStr length]<=5){
        [NSException raise:@"图片名错误" format:@"检查你的图片名称是不是错的？或者helpPageMaxNum未设置！"];
    }
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalStr options:NSLayoutFormatDirectionLeftToRight metrics:nil views:self.imageViewDic]];
    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = _scrollView.frame.size.width;
    self.currPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.pageControl setCurrentPage:self.currPage];
    //    _pageControl.currentPage = page;
    
    if(_currPage == 0){
        self.preBt.hidden = YES;
        self.nextBt.hidden = NO;
    }else if(_currPage == ((self.helpPageMaxNum-self.errorKeys.count)-1)){
        self.preBt.hidden = NO;
        self.nextBt.hidden = YES;
        self.enterBt.hidden = NO;
    }else{
        self.preBt.hidden = NO;
        self.nextBt.hidden = NO;
    }
}

-(void)preBtTapped:(id)sender{
    
    float offsetX = (_currPage-1)*self.scrollView.frame.size.width;
    if(offsetX >=0 &&offsetX < self.scrollView.contentSize.width){
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

-(void)nextBtTapped:(id)sender{
    float offsetX = (_currPage+1)*self.scrollView.frame.size.width;
    if(offsetX >= 0 && offsetX <self.scrollView.contentSize.width){
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

-(void)enterBtTapped:(id)sender{
    [self performSegueWithIdentifier:_segueIndentity sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end