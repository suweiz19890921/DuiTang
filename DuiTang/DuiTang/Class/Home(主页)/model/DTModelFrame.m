//
//  DTModelFrame.m
//  DuiTang
//
//  Created by qianfeng on 16/3/7.
//  Copyright © 2016年 Monky. All rights reserved.
//

#import "DTModelFrame.h"
#import "DTHomeModel.h"
#define maxWidth [UIScreen mainScreen] .bounds.size.width-90


@implementation DTModelFrame

/**
 根据字体获得size的方法抽出
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW str: (NSString *)str
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    
        return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}


//模型赋值
-(void)setModel:(DTHomeModel *)model
{
    _model = model;
    
    CGFloat imageW = 80;
    CGFloat imageH = 80;
    if ([model.style isEqualToString:@"large"]) {
        imageW = 350;
        imageH = 200;
        
    }
    
        CGFloat imageX = homePedding;
        CGFloat imageY = homePedding;
    
        self.iconFrame= CGRectMake(imageX, imageY, imageW, imageH);
    
    
    
        CGFloat titleX = homePedding+CGRectGetMaxX(self.iconFrame);
        CGFloat titleY = imageY;
    CGSize titleSize = [self sizeWithFont:titleFont maxW:maxWidth str:model.des];
    self.titleFrame = (CGRect){{titleX,titleY},titleSize};
    
    
        CGFloat contentX = titleX;
    CGFloat contentY = homePedding+CGRectGetMaxY(self.titleFrame);
       CGSize contentSize = [self sizeWithFont:otherFont maxW:maxWidth str:model.stitle];
    self.contentFrame = (CGRect){{contentX,contentY},contentSize};
    
    
    
        CGFloat readX = titleX;
        CGFloat readY = CGRectGetMaxY(self.contentFrame)+2*homePedding;
    CGSize readSize = [self sizeWithFont:otherFont maxW:maxWidth str:model.dynamic_info];
    
    self.dyInfoFrame = (CGRect){{readX,readY},readSize};
    
    self.maxHight = CGRectGetMaxY(self.dyInfoFrame);
    }

  

@end
