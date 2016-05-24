//
//  DoNotUseTableViewCell.m
//  feichacha
//
//  Created by wt on 16/4/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "DoNotUseTableViewCell.h"

@implementation DoNotUseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _notUseButton.layer.cornerRadius = 4;
    _notUseButton.layer.borderColor = RGBCOLORA(243, 229, 200, 1).CGColor;
    _notUseButton.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
