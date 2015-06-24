//
//  PHHTBBaseHandler.m
//  ParkHereCoupon
//
//  Created by liu poolo on 15/4/27.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import "PHHTBBaseHandler.h"

@implementation PHHTBBaseHandler


+(instancetype)handlerWithDataArray:(NSArray*) dataArray identifier:(NSString *)identifier setCellBlk:(setCellBlk) blk{
    PHHTBBaseHandler *result = [[[self class] alloc] init];
    result.dataArray = dataArray;
    result.identifier = identifier;
    result.setCellBlk = blk;
    
    return result;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
    id model = [self modelForIndexPath:indexPath];
    self.setCellBlk(cell,model);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

-(id)modelForIndexPath:(NSIndexPath*) indexPath{
    return [self.dataArray objectAtIndex:indexPath.row];
}



@end
