//
//  taiwaneseFoodTableViewCell.m
//  feichacha
//
//  Created by wt on 16/5/20.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "taiwaneseFoodTableViewCell.h"

@implementation taiwaneseFoodTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _buyButton.layer.cornerRadius = 4;
    _buyButton2.layer.cornerRadius = 4;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
