//
//  DTDiscuss.h
//  DuiTang
//
//  Created by 苏威 on 16/3/10.
//  Copyright © 2016年 Monky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSender.h"

@interface DTDiscuss : NSObject
@property (copy ,nonatomic) NSString * active_time;
@property (copy ,nonatomic) NSString * add_datetime_ts;
@property (copy ,nonatomic) NSString * category;
@property (copy ,nonatomic) NSString * club;
@property (copy ,nonatomic) NSString * comment_count;
@property (copy ,nonatomic) NSString * content;
@property (copy ,nonatomic) NSString * cid;
@property (copy ,nonatomic) NSArray * photos;
@property (copy ,nonatomic) DTSender * sender;
@property (copy ,nonatomic) NSString * share_links;
@property (copy ,nonatomic) NSString * visit_count;


@end
