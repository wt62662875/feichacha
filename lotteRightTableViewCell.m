//
//  lotteRightTableViewCell.m
//  feichacha
//
//  Created by wt on 16/6/28.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "lotteRightTableViewCell.h"

@implementation lotteRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _buyButton.layer.cornerRadius = 15;
    _backView.layer.borderWidth = 0.5;
    _backView.layer.borderColor = RGBCOLORA(241, 241, 241, 1).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
