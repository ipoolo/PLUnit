//
//  PHHTBBaseHandler.h
//  ParkHereCoupon
//
//  Created by liu poolo on 15/4/27.
//  Copyright (c) 2015年 parkingwang_ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^setCellBlk)(id,id);
@interface PHHTBBaseHandler : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,copy) NSArray *dataArray;
@property (nonatomic,strong) setCellBlk setCellBlk;
@property (nonatomic,strong) NSString *identifier;
//@property id delegate;delegate让具体子类来设置

+(instancetype)handlerWithDataArray:(NSArray*) dataArray identifier:(NSString *)identifier setCellBlk:(setCellBlk) blk;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(id)modelForIndexPath:(NSIndexPath*) indexPath;

@end
