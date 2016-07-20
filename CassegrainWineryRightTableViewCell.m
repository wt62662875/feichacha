//
//  CassegrainWineryRightTableViewCell.m
//  feichacha
//
//  Created by wt on 16/7/12.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "CassegrainWineryRightTableViewCell.h"

@implementation CassegrainWineryRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _buyButton.layer.cornerRadius = 4;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
