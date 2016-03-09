//
//  DTReadModel.h
//  DuiTang
//
//  Created by Dylan on 3/7/16.
//  Copyright © 2016 Monky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@class DTReadCoverModel;

@interface DTReadModel : JSONModel
@property (nonatomic,strong)NSNumber * active_time;
@property (nonatomic,strong)NSNumber * add_datetime_ts;
@property (nonatomic,strong)NSString * category;

@property (nonatomic,strong)NSDictionary * club;
@property (nonatomic,strong)NSNumber * comment_count;
@property (nonatomic,strong)NSString * content;
//第一个model
@property (nonatomic,strong)DTReadCoverModel * cover;
@property (nonatomic,strong)NSString * icon_url;
@property (nonatomic,strong)NSNumber * ID;

@property (nonatomic,strong)NSDictionary * photos;
@property (nonatomic,strong)NSDictionary * sender;
@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSNumber * visit_count;
@end

@interface DTReadCoverModel : JSONModel
@property (nonatomic,strong)NSString * cover_desc;
@property (nonatomic,strong)NSNumber * ID;
@property (nonatomic,strong)NSString * photo_path;
@end;