//
//  myOrderTableViewCell.m
//  feichacha
//
//  Created by wt on 16/4/27.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "myOrderTableViewCell.h"

@implementation myOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _footButton.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
