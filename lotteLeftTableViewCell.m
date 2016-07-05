//
//  lotteLeftTableViewCell.m
//  feichacha
//
//  Created by wt on 16/6/28.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "lotteLeftTableViewCell.h"

@implementation lotteLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _buyButton.layer.cornerRadius = 15;
    _backView.layer.borderWidth = 0.5;
    _backView.layer.borderColor = RGBCOLORA(241, 241, 241, 1).CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
