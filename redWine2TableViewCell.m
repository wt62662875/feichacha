//
//  redWine2TableViewCell.m
//  feichacha
//
//  Created by wt on 16/7/8.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "redWine2TableViewCell.h"

@implementation redWine2TableViewCell

- (void)awakeFromNib {
    // Initialization code
    _backView1.layer.cornerRadius = 4;
    _backView2.layer.cornerRadius = 4;
    
    _buyButton1.layer.cornerRadius = 4;
    _buyButton2.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
