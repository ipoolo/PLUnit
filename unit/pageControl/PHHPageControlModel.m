//
//  PHHPageControlModel.m
//  poolo
//
//  Created by liu poolo on 15/5/3.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import "PHHPageControlModel.h"

@implementation PHHPageControlModel

@synthesize currPage = _currPage;
@synthesize maxValue = _maxValue;
@synthesize minPage = _minPage;
@synthesize perPageCounts = _perPageCounts;


-(instancetype)init{
    self = [super init];
    if(self){
        [self configDefaultValue];
    }
    return self;
}

-(instancetype)initWithPerPageCounts:(NSUInteger) perPageCounts{
    self = [self init];
    _perPageCounts = perPageCounts;
    return self;
}

#pragma mark - private Methon
-(void)configDefaultValue{
    _currPage = 1;
    _maxPage = 1;
    _minPage = 1;
    _perPageCounts = 1;
    _maxValue = 1;
}



-(void)turnToFirstPage{
    [self setCurrPage:self.minPage];
}

-(void)turnToLastPage{
    [self setCurrPage:self.maxPage];
}

-(BOOL)hasNextPage{
    if(self.currPage+1>self.maxPage){
        return NO;
    }else{
        return YES;
    }
}
-(void)turnToNextPage{
    [self setCurrPage:self.currPage+1];
}

-(BOOL)hasPrePage{
    if(self.currPage-1<self.minPage){
        return NO;
    }else{
        return YES;
    }
}

-(void)turnToPrePage{
    [self setCurrPage:self.currPage-1];
}

-(BOOL)hasPage:(NSUInteger) page{
    if(page<=self.maxPage&&page>=self.minPage){
        return YES;
    }else{
        return NO;
    }
}

-(void)turnToPage:(NSUInteger) page{
    [self setCurrPage:page];
}

#pragma mark - get/set
-(NSUInteger)currPage{
    return _currPage;
}

-(void)setCurrPage:(NSUInteger)currPage{
    
    if(currPage!=_currPage){
        if(currPage > self.maxPage){
            [NSException raise:@"PHHPageOutOfSize" format:@"currPage>maxPage[%@] 设置页码前 请先调用相关hasPage/hasPrePage/currPage 以确定存在此页" ,@(self.maxPage)];
            return;
        }else if(currPage < self.minPage){
            [NSException raise:@"PHHPageOutOfSize" format:@"currPage<minPage[%@] 设置页码前 请先调用相关hasPage/hasPrePage/currPage 以确定存在此页" ,@(self.minPage)];
            return;
        }
        _currPage = currPage;
    }
}

-(NSUInteger)maxValue{
    return _maxValue;
}

-(void)setMaxValue:(NSUInteger)maxValue{
    
    if(maxValue!=_maxValue){
        _maxValue = maxValue;
        _maxPage = maxValue/self.perPageCounts+(maxValue%self.perPageCounts?1:0);
    }
}

-(NSUInteger)minPage{
    return _minPage;
}

-(void)setMinPage:(NSUInteger)minPage{
    if(minPage!=_minPage){
        if(minPage<1){
            [NSException raise:@"PHHMinPageOutlessThanOne" format:@"minPage[%@]必须大于等于1 " ,@(self.minPage)];
            return;
        }else if(minPage>_maxPage){
            [NSException raise:@"PHHMinPageGreaterThanMaxPage" format:@"minPage[%@]必须小于等于MaxPage " ,@(self.minPage)];
            return;
        }
        _minPage = minPage;
    }
}

-(NSUInteger)perPageCounts{
    return _perPageCounts;
}

-(void)setPerPageCounts:(NSUInteger)perPageCounts{
    if(perPageCounts!=_perPageCounts){
        if(perPageCounts!=0){
            _perPageCounts = perPageCounts;
            _maxPage = self.maxValue/perPageCounts+(self.maxValue%perPageCounts?1:0);
        }else{
            [NSException raise:@"PHHPerPageCountsIsZero" format:@"perPageCounts不能为0 "];
            return;
        }
    }
}

-(NSUInteger)lastPage{
   return self.maxPage;
}


-(NSUInteger)firstPage{
    return self.minPage;
}



@end
