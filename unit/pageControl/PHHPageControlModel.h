//
//  PHHPageControlModel.h
//  poolo
//
//  Created by liu poolo on 15/5/3.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHHPageControlModel : NSObject

@property (nonatomic,assign,readonly) NSUInteger currPage;
@property (nonatomic,assign,readonly) NSUInteger maxPage;
@property (nonatomic,assign) NSUInteger maxValue;
@property (nonatomic,assign) NSUInteger minPage;
@property (nonatomic,assign) NSUInteger perPageCounts;

-(instancetype)initWithPerPageCounts:(NSUInteger) perPageCounts;

-(void)turnToFirstPage;
-(void)turnToLastPage;

-(BOOL)hasNextPage;
-(void)turnToNextPage;

-(BOOL)hasPrePage;
-(void)turnToPrePage;

-(BOOL)hasPage:(NSUInteger) page;
-(void)turnToPage:(NSUInteger) page;

-(NSUInteger)lastPage;

-(NSUInteger)firstPage;

@end
