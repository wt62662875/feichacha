//
//  goodsDetailsTableViewCell.m
//  feichacha
//
//  Created by wt on 16/5/6.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "goodsDetailsTableViewCell.h"

@implementation goodsDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _SalesPromotion1.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
