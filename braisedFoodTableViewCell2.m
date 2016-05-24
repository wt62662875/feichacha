//
//  braisedFoodTableViewCell2.m
//  feichacha
//
//  Created by wt on 16/5/12.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "braisedFoodTableViewCell2.h"

@implementation braisedFoodTableViewCell2

- (void)awakeFromNib {
    // Initialization code
    _backView1.layer.borderColor = RGBCOLORA(150, 2, 25, 1).CGColor;
    _backView1.layer.borderWidth = 1;
    _backView2.layer.borderColor = RGBCOLORA(150, 2, 25, 1).CGColor;
    _backView2.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
