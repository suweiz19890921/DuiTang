//
//  DTBigTableViewCell.m
//  DuiTang
//
//  Created by qianfeng on 16/3/7.
//  Copyright © 2016年 Monky. All rights reserved.
//

#import "DTBigTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface DTBigTableViewCell ()

@property (weak ,nonatomic)UIImageView *iconImageView;
@property (weak ,nonatomic) UILabel *readLabel;
@property (weak ,nonatomic)UILabel *contentLabel;
@property (weak ,nonatomic)UILabel *titleLabel;
@end
@implementation DTBigTableViewCell



+(id)bigTableViewCellWithTableView:(UITableView *)tableView;
{
    NSString *className =NSStringFromClass([self class]);
    DTBigTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:className];
    if (cell==nil) {
        cell = [[DTBigTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *iconImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView =iconImageView;
        
        
        UILabel *titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:titleLabel];
        self.titleLabel= titleLabel;
        self.titleLabel.font = titleFont;
        titleLabel.numberOfLines = 0;
        
        
        
        UILabel *contentLabel = [[UILabel alloc]init];
        [self.contentView addSubview:contentLabel];
        self.contentLabel= contentLabel;
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.numberOfLines = 0;
        
        contentLabel.font = otherFont;
        
        UILabel *readLabel = [[UILabel alloc]init];
        [self.contentView addSubview:readLabel];
        self.readLabel = readLabel;
        readLabel.font = otherFont;
        readLabel.numberOfLines = 0;
        
    }
    return self;
}
-(void)setModel:(DTBigModelFrame *)model
{
    _model = model;
    DTBigModel *hModel=model.model;
    //NSLog(@"%@",hModel.image_url);
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:hModel.image_url]];
    self.iconImageView.frame = model.iconFrame;
    
    self.titleLabel.text = hModel.des;
    // NSLog(@"%@",hModel.des);
    self.titleLabel.frame = model.titleFrame;
    self.titleLabel.textColor = [UIColor redColor];
    
    self.contentLabel.text = hModel.stitle;
    self.contentLabel.frame = model.contentFrame;
    self.contentLabel.textColor = [UIColor whiteColor];

    
    self.readLabel.text = hModel.dynamic_info;
    self.readLabel.frame = model .dyInfoFrame;
}


@end
