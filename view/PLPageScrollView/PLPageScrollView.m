//
//  PLPageScrollView.m
//  PLPageScrollView
//
//  Created by liu poolo on 14/12/14.
//  Copyright (c) 2014年 liu poolo. All rights reserved.
//

#import "PLPageScrollView.h"

@interface PLPageScrollView ()

@property (strong, nonatomic) UIButton *preBt;
@property (strong, nonatomic) UIButton *nextBt;

@property (nonatomic,copy) NSArray *imageArray;
@property (nonatomic,copy) NSDictionary *imageViewDic;
@property (nonatomic,copy) NSDictionary *errorKeys;
@property (nonatomic,assign) int currPage;
@property (strong,nonatomic) UIView *placeHolderView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIPageControl *pageControl;
@property (strong,nonatomic) UIView *coverView;

@property (assign,nonatomic) float coverViewAlpha;

@property (assign, nonatomic) int helpPageMaxNum;
@property (strong,nonatomic) NSString *prefixName;

@end

@implementation PLPageScrollView

-(instancetype)init{
    self=[super init];
    if(self){
        self.coverViewAlpha = 0.7f;
    }
    return self;
}
+(instancetype)pageScrollViewHelpPageMaxNum:(int) maxNum prefixFileStr:(NSString* )prefixName{
    PLPageScrollView* pageScrollView = [[PLPageScrollView alloc] init];
    pageScrollView.helpPageMaxNum = maxNum;
    pageScrollView.prefixName = prefixName;
    NSMutableArray *mArray = [@[] mutableCopy];
    for(int i=0;i<=maxNum;i++){
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",prefixName,i]];
        if(image){
            [mArray addObject:image];
        }else{
            [mArray addObject:[[UIImage alloc] init]];
            NSLog(@"[E]-%@_ImageName:%@",@"ImageNameError",[NSString stringWithFormat:@"%@%d",prefixName,i]);
        }
    }
    pageScrollView.imageArray = mArray;
    [pageScrollView configInit];
    return pageScrollView;
}

+(instancetype)pageScrollViewPageMaxNum:(int) maxNum prefixFileStr:(NSString* )prefixName coverViewAlpha:(float)alpha{
    PLPageScrollView* pageScrollView = [[PLPageScrollView alloc] init];
    pageScrollView.helpPageMaxNum = maxNum;
    pageScrollView.prefixName = prefixName;
    NSMutableArray *mArray = [@[] mutableCopy];
    for(int i=0;i<=maxNum;i++){
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",prefixName,i]];
        if(image){
            [mArray addObject:image];
        }else{
            [mArray addObject:[[UIImage alloc] init]];
            NSLog(@"[E]-%@_ImageName:%@",@"ImageNameError",[NSString stringWithFormat:@"%@%d",prefixName,i]);
        }
    }
    pageScrollView.imageArray = mArray;
    if(alpha>1){
        pageScrollView.coverViewAlpha = 1.f;
    }else if(alpha<=0){
        pageScrollView.coverViewAlpha = 0.f;
    }else{
        pageScrollView.coverViewAlpha = alpha;
    }
    [pageScrollView configInit];
    return pageScrollView;
}

+(instancetype)pageScrollViewShowImageNames:(NSArray *)nameArray{
    PLPageScrollView* pageScrollView = [[PLPageScrollView alloc] init];
    NSMutableArray *mArray = [@[] mutableCopy];
    [nameArray enumerateObjectsUsingBlock:^(NSString* name, NSUInteger idx, BOOL *stop) {
        UIImage* image = [UIImage imageNamed:name];
        if(image){
            [mArray addObject:image];
        }else{
            [mArray addObject:[[UIImage alloc] init]];
            NSLog(@"[E]-%@_ImageName:%@",@"ImageNameError",name);
        }
    }];
    pageScrollView.imageArray = mArray;
    [pageScrollView configInit];
    return pageScrollView;
}

+(instancetype)pageScrollViewShowImageNames:(NSArray *)nameArray coverViewAlpha:(float)alpha{
    PLPageScrollView* pageScrollView = [[PLPageScrollView alloc] init];
    NSMutableArray *mArray = [@[] mutableCopy];
    [nameArray enumerateObjectsUsingBlock:^(NSString* name, NSUInteger idx, BOOL *stop) {
        UIImage* image = [UIImage imageNamed:name];
        if(image){
            [mArray addObject:image];
        }else{
            [mArray addObject:[[UIImage alloc] init]];
            NSLog(@"[E]-%@_ImageName:%@",@"ImageNameError",name);
        }
    }];
    if(alpha>1){
        pageScrollView.coverViewAlpha = 1.f;
    }else if(alpha<=0){
        pageScrollView.coverViewAlpha = 0.f;
    }else{
        pageScrollView.coverViewAlpha = alpha;
    }
    pageScrollView.imageArray = mArray;
    [pageScrollView configInit];
    return pageScrollView;
}

+(instancetype)pageScrollViewShowImageObjects:(NSArray *)imageArray{
    PLPageScrollView* pageScrollView = [[PLPageScrollView alloc] init];
    pageScrollView.imageArray = imageArray;
    [pageScrollView configInit];
    return pageScrollView;
}

+(instancetype)pageScrollViewShowImageObjects:(NSArray *)imageArray coverViewAlpha:(float)alpha{
    PLPageScrollView* pageScrollView = [[PLPageScrollView alloc] init];
    if(alpha>1){
        pageScrollView.coverViewAlpha = 1.f;
    }else if(alpha<=0){
        pageScrollView.coverViewAlpha = 0.f;
    }else{
        pageScrollView.coverViewAlpha = alpha;
    }
    pageScrollView.imageArray = imageArray;
    [pageScrollView configInit];
    return pageScrollView;}

-(void)configInit{
    [self configView];
    [self configConstraints];

}

-(void)configInitPage{

    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0)animated:NO];

}

- (void)configView{
    
    //configScrollView
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.scrollView];
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
    
    [self addSubview:self.coverView];
    
    //configPageControl
    self.pageControl = [[UIPageControl alloc] init];
    [self.pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.pageControl];
    
    
    //placeHolderView
    self.placeHolderView = [[UIView alloc] init];
    [self.placeHolderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView addSubview:self.placeHolderView];
    
    NSMutableDictionary *tempMDic = [@{} mutableCopy];
    NSMutableDictionary *tempErrorKeys= [@{} mutableCopy];
    if(self.imageArray&&[self.imageArray count]){
        [self.imageArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
            UIImageView* tempImageView = [[UIImageView alloc] init];
            [tempImageView setTag:idx];
            [tempImageView setImage:image];
            [tempImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [tempImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageViewTapped:)]];
            [tempImageView setUserInteractionEnabled:YES];
            [self.scrollView addSubview:tempImageView];
            [tempMDic setObject:tempImageView forKey:[NSString stringWithFormat:@"key%lu",(unsigned long)idx]];
        }];
    }
    UIImageView* preImageView = [[UIImageView alloc] init];
    [preImageView setTag:-1];
    [preImageView setImage:[self.imageArray objectAtIndex:[self.imageArray count]-1]];
    [preImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [preImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageViewTapped:)]];
    [preImageView setUserInteractionEnabled:YES];
    [self.scrollView addSubview:preImageView];
    [tempMDic setObject:preImageView forKey:@"keyPre"];
    
    UIImageView* lastImageView = [[UIImageView alloc] init];
    [lastImageView setTag:[self.imageArray count]];
    [lastImageView setImage:[self.imageArray objectAtIndex:0]];
    [lastImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [lastImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageViewTapped:)]];
    [lastImageView setUserInteractionEnabled:YES];
    [self.scrollView addSubview:lastImageView];
    [tempMDic setObject:lastImageView forKey:@"keyLast"];

    self.errorKeys = tempErrorKeys;
    self.imageViewDic = tempMDic;
    [self.pageControl setNumberOfPages:([self.imageArray count])];
    
    
    self.preBt.hidden = YES;
    self.nextBt.hidden = NO;

    
    [self.preBt addTarget:self action:@selector(preBtTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBt addTarget:self action:@selector(nextBtTapped:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configConstraints{
    NSDictionary* views = NSDictionaryOfVariableBindings(_scrollView,_coverView,_pageControl);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_scrollView]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_coverView]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_pageControl]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_scrollView]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_coverView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_coverView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    views = NSDictionaryOfVariableBindings(_placeHolderView);
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_placeHolderView]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_placeHolderView]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.placeHolderView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1*(self.imageArray.count+2) constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.placeHolderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    
    //configImageViews
    NSMutableString* horizontalStr = [@"|-0-[keyPre(==key0)]-0-" mutableCopy];
    if(self.imageArray.count>0){
        for(int i=0;i<self.imageArray.count;i++){
            if(![self.errorKeys objectForKey:[NSString stringWithFormat:@"key%d",i]]){
                [horizontalStr appendFormat:@"[key%d(==key0)]-0-",i];
                [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[key%d]-0-|",i] options:NSLayoutFormatDirectionLeftToRight metrics:nil views:self.imageViewDic]];
            }
        }
    }
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[keyPre]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:self.imageViewDic]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[keyLast]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:self.imageViewDic]];
    [horizontalStr appendFormat:@"[keyLast(==key0)]-0-|"];
    if([horizontalStr length]<=[@"|-0-[keyPre(==key0)]-0-[keyLast(==key0)]-0-|" length]){
        [NSException raise:@"图片名错误" format:@"检查你的图片名称是不是错的？或者helpPageMaxNum未设置！"];
    }
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalStr options:NSLayoutFormatDirectionLeftToRight metrics:nil views:self.imageViewDic]];
    

    
}


#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if(scrollView.contentOffset.x >= (scrollView.frame.size.width*(self.imageArray.count+1))-1){
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
        [self.pageControl setCurrentPage:0];
    }else if(scrollView.contentOffset.x <= 0){
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width*self.imageArray.count, 0);
        [self.pageControl setCurrentPage:self.pageControl.numberOfPages-1];
        
    }else{
        int page = scrollView.contentOffset.x/scrollView.frame.size.width - 1;
        [self.pageControl setCurrentPage:page];
    }

    
    //    _pageControl.currentPage = page;
    
    if(self.pageControl.currentPage == 0){
        self.preBt.hidden = YES;
        self.nextBt.hidden = NO;
    }else if(self.pageControl.currentPage == ((self.imageArray.count)-1)){
        self.preBt.hidden = NO;
        self.nextBt.hidden = YES;
    }else{
        self.preBt.hidden = NO;
        self.nextBt.hidden = NO;
    }
}

-(void)preBtTapped:(id)sender{
    
    float offsetX = (_currPage-1)*self.scrollView.bounds.size.width;
    if(offsetX >=0 &&offsetX < self.scrollView.contentSize.width){
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

-(void)nextBtTapped:(id)sender{
    float offsetX = (_currPage+1)*self.scrollView.bounds.size.width;
    if(offsetX >= 0 && offsetX <self.scrollView.contentSize.width){
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

-(void)setImage:(UIImage *)image inPageIndex:(int) index{
    if(index<[self.imageArray count]){
        NSMutableArray *mArray = [self.imageArray mutableCopy];
        [mArray replaceObjectAtIndex:index withObject:image];
        self.imageArray = mArray;
        NSMutableDictionary *mdic = [self.imageViewDic mutableCopy];
        UIImageView *imageView=(UIImageView *)mdic[[NSString stringWithFormat:@"key%d",index]];
        [imageView setImage:image];
        [mdic setObject:imageView forKey:[NSString stringWithFormat:@"key%d",index]];
        self.imageViewDic = mdic;
    }
}

-(void)showImageViewTapped:(UITapGestureRecognizer *)gesture{
    [self.delegate pageScrollViewTappedWithSender:(UIImageView *)gesture.view pageIndex:(int)gesture.view.tag];
}


@end
