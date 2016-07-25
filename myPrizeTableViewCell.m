//
//  myPrizeTableViewCell.m
//  feichacha
//
//  Created by wt on 16/7/24.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "myPrizeTableViewCell.h"

@implementation myPrizeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _roundView.layer.cornerRadius = 25;
    
}
-(void)layoutSubviews{
    _roundViewLeft.constant = SCREENWIDTH/8-15;
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
