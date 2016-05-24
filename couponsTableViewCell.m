//
//  couponsTableViewCell.m
//  feichacha
//
//  Created by wt on 16/4/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "couponsTableViewCell.h"

@implementation couponsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _roundView.layer.cornerRadius = 25;
    
}
-(void)layoutSubviews{
    _roundViewLeft.constant = SCREENWIDTH/8-15;
    _checkReasonButtonLeft.constant = SCREENWIDTH/8-10;
    _label1X.constant = SCREENWIDTH/320*39;
    _line1Left.constant = SCREENWIDTH/320*98;
    _label3Width.constant = SCREENWIDTH/320*204;
    _line3Width.constant = SCREENWIDTH/320*174;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
