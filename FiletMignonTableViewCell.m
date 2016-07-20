//
//  FiletMignonTableViewCell.m
//  feichacha
//
//  Created by wt on 16/7/8.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "FiletMignonTableViewCell.h"

@implementation FiletMignonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    _backView.layer.cornerRadius = 4;
    _backView.layer.masksToBounds = YES;
    _buyButton.layer.cornerRadius = 12.5;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
