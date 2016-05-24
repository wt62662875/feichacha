//
//  freshFruitTableViewCell2.m
//  feichacha
//
//  Created by wt on 16/5/11.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "freshFruitTableViewCell2.h"

@implementation freshFruitTableViewCell2

- (void)awakeFromNib {
    // Initialization code
    self.backView1.layer.cornerRadius = 4;
    self.backView1.layer.masksToBounds = YES;
    self.backView2.layer.cornerRadius = 4;
    self.backView2.layer.masksToBounds = YES;
    self.buyButton1.layer.cornerRadius = 4;
    self.buyButton2.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
