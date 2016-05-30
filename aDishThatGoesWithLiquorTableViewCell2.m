//
//  aDishThatGoesWithLiquorTableViewCell2.m
//  feichacha
//
//  Created by wt on 16/5/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "aDishThatGoesWithLiquorTableViewCell2.h"

@implementation aDishThatGoesWithLiquorTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    _goodsImage.layer.cornerRadius = 54;
    _goodsImage.layer.masksToBounds = YES;
    // Initialization code
    _buyButton.titleLabel.numberOfLines = 0;
    [_buyButton setTitle:@"点击\n抢购" forState:UIControlStateNormal];
    _buyButton.layer.cornerRadius = 30;
    _buyButton.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
