//
//  submitOrderGoodsTableViewCell.m
//  feichacha
//
//  Created by wt on 16/5/5.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "submitOrderGoodsTableViewCell.h"

@implementation submitOrderGoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _goodsDescribe.layer.borderColor = [UIColor redColor].CGColor;
    _goodsDescribe.layer.borderWidth = 1;
    _goodsDescribe.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
