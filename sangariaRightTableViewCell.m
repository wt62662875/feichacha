//
//  sangariaRightTableViewCell.m
//  feichacha
//
//  Created by wt on 16/7/6.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "sangariaRightTableViewCell.h"

@implementation sangariaRightTableViewCell

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
