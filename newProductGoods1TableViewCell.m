//
//  newProductGoods1TableViewCell.m
//  feichacha
//
//  Created by wt on 16/5/8.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "newProductGoods1TableViewCell.h"

@implementation newProductGoods1TableViewCell

- (void)awakeFromNib {
    // Initialization code
    _backView.layer.cornerRadius = 4;
    _backView.layer.masksToBounds = YES;
    _buyButton.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
