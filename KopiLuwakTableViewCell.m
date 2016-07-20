//
//  KopiLuwakTableViewCell.m
//  feichacha
//
//  Created by wt on 16/7/6.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "KopiLuwakTableViewCell.h"

@implementation KopiLuwakTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    _backView.layer.cornerRadius = 4;
    _buyButton.layer.cornerRadius = 4;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
