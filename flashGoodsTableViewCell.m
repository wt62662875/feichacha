//
//  flashGoodsTableViewCell.m
//  feichacha
//
//  Created by wt on 16/4/24.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "flashGoodsTableViewCell.h"

@implementation flashGoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _goodsDescribe.layer.borderColor = [UIColor redColor].CGColor;
    _goodsDescribe.layer.borderWidth = 1;
    _goodsDescribe.layer.cornerRadius = 8;
    
    _goodsDescribe2.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
    _goodsDescribe2.layer.borderWidth = 1;
    _goodsDescribe2.layer.cornerRadius = 8;
    
    _goodsDescribe3.layer.cornerRadius = 4;
    _goodsDescribe3.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
