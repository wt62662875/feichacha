//
//  headlinesTableViewCell.h
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface headlinesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *salesPromotionLabel;
@property (weak, nonatomic) IBOutlet UILabel *SalesPromotionMessageLabel;       //促销信息

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage1;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage2;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage3;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2_right;


@property (weak, nonatomic) IBOutlet UIButton *salesPromotionClick;         //促销按钮
@property (weak, nonatomic) IBOutlet UIButton *classClick1;                 //分类按钮
@property (weak, nonatomic) IBOutlet UIButton *classClick2;
@property (weak, nonatomic) IBOutlet UIButton *classClick3;

@end
