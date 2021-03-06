//
//  goodsProjectTableViewCell.m
//  feichacha
//
//  Created by wt on 16/4/22.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "goodsProjectTableViewCell.h"

@implementation goodsProjectTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _goodsDescribe1_1.layer.borderColor = [UIColor redColor].CGColor;
    _goodsDescribe1_1.layer.borderWidth = 1;
    _goodsDescribe1_1.layer.cornerRadius = 8;
    
    _goodsDescribe1_2.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
    _goodsDescribe1_2.layer.borderWidth = 1;
    _goodsDescribe1_2.layer.cornerRadius = 8;
    
    _goodsDescribe1_3.layer.cornerRadius = 4;
    _goodsDescribe1_3.layer.masksToBounds = YES;
    
    _goodsDescribe2_1.layer.borderColor = [UIColor redColor].CGColor;
    _goodsDescribe2_1.layer.borderWidth = 1;
    _goodsDescribe2_1.layer.cornerRadius = 8;
    
    _goodsDescribe2_2.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
    _goodsDescribe2_2.layer.borderWidth = 1;
    _goodsDescribe2_2.layer.cornerRadius = 8;
    
    _goodsDescribe2_3.layer.cornerRadius = 4;
    _goodsDescribe2_3.layer.masksToBounds = YES;
    
    _goodsDescribe3_1.layer.borderColor = [UIColor redColor].CGColor;
    _goodsDescribe3_1.layer.borderWidth = 1;
    _goodsDescribe3_1.layer.cornerRadius = 8;
    
    _goodsDescribe3_2.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
    _goodsDescribe3_2.layer.borderWidth = 1;
    _goodsDescribe3_2.layer.cornerRadius = 8;
    
    _goodsDescribe3_3.layer.cornerRadius = 4;
    _goodsDescribe3_3.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    _line1_left.constant = SCREENWIDTH/3;
    _line2_right.constant = SCREENWIDTH/3;
    
    //    _left.constant = 100;
    
}
@end
