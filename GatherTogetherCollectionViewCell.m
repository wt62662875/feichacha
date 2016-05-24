//
//  GatherTogetherCollectionViewCell.m
//  feichacha
//
//  Created by wt on 16/4/28.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "GatherTogetherCollectionViewCell.h"

@implementation GatherTogetherCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _goodsDescribe1.layer.borderColor = [UIColor redColor].CGColor;
    _goodsDescribe1.layer.borderWidth = 1;
    _goodsDescribe1.layer.cornerRadius = 8;
    
    _goodsDescribe2.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
    _goodsDescribe2.layer.borderWidth = 1;
    _goodsDescribe2.layer.cornerRadius = 8;
    
    _goodsDescribe3.layer.cornerRadius = 4;
    _goodsDescribe3.layer.masksToBounds = YES;
}

@end
