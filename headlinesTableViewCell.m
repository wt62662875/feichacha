//
//  headlinesTableViewCell.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "headlinesTableViewCell.h"

@implementation headlinesTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _salesPromotionLabel.layer.cornerRadius = 6.0;
    _salesPromotionLabel.layer.borderWidth = 1;
    _salesPromotionLabel.layer.borderColor = RGBCOLORA(205, 12, 12, 1).CGColor;
}

-(void)layoutSubviews{
    _line1_left.constant = SCREENWIDTH/3;
    _line2_right.constant = SCREENWIDTH/3;

//    _left.constant = 100;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
