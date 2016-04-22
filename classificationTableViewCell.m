//
//  classificationTableViewCell.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "classificationTableViewCell.h"

@implementation classificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)drawRect:(CGRect)rect{
    [_classButton1 setFrame:CGRectMake(SCREENWIDTH/8-20, 8, 40, 40)];
    [_classButton2 setFrame:CGRectMake(SCREENWIDTH/8*3-20, 8, 40, 40)];
    [_classButton3 setFrame:CGRectMake(SCREENWIDTH/8*5-20, 8, 40, 40)];
    [_classButton4 setFrame:CGRectMake(SCREENWIDTH/8*7-20, 8, 40, 40)];
    [_classLabel1 setFrame:CGRectMake(SCREENWIDTH/8-20, 55, 40, 15)];
    [_classLabel2 setFrame:CGRectMake(SCREENWIDTH/8*3-20, 55, 40, 15)];
    [_classLabel3 setFrame:CGRectMake(SCREENWIDTH/8*5-20, 55, 40, 15)];
    [_classLabel4 setFrame:CGRectMake(SCREENWIDTH/8*7-20, 55, 40, 15)];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
