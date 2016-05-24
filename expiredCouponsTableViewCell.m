//
//  expiredCouponsTableViewCell.m
//  feichacha
//
//  Created by wt on 16/4/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "expiredCouponsTableViewCell.h"

@implementation expiredCouponsTableViewCell

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
-(void)drawRect:(CGRect)rect{

//    [_backImage setFrame:CGRectMake(8, 8, SCREENWIDTH-16, 111)];
//    [_roundView setFrame:CGRectMake(SCREENWIDTH*0.3/2-25, 32, 50, 50)];
//    [_checkReasonButton setFrame:CGRectMake(SCREENWIDTH*0.3/2-20, 80, 40, 24)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
