//
//  freshFruitTableViewCell1.h
//  feichacha
//
//  Created by wt on 16/5/11.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface freshFruitTableViewCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *specifications;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@end