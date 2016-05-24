//
//  salesPromotionGoodsTableViewCell.m
//  feichacha
//
//  Created by wt on 16/5/9.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "salesPromotionGoodsTableViewCell.h"

@implementation salesPromotionGoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backView.layer.cornerRadius = 4;
    self.backView.layer.masksToBounds = YES;
    
    _goodsImage.layer.cornerRadius = 4;
    _goodsImage.layer.masksToBounds = YES;
    
    _buyButton.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
