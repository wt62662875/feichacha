//
//  newProductTitleTableViewCell.m
//  feichacha
//
//  Created by wt on 16/5/8.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "newProductTitleTableViewCell.h"

@implementation newProductTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _backView.layer.cornerRadius = 4;
    _backView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
