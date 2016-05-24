//
//  newProductGoods2TableViewCell.h
//  feichacha
//
//  Created by wt on 16/5/8.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newProductGoods2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UIView *backView2;


@property (weak, nonatomic) IBOutlet UIImageView *goodsImage1;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage2;

@property (weak, nonatomic) IBOutlet UILabel *goodsName1;
@property (weak, nonatomic) IBOutlet UILabel *goodsName2;

@property (weak, nonatomic) IBOutlet UILabel *goodsSpecifications1;     //规格
@property (weak, nonatomic) IBOutlet UILabel *goodsSpecifications2;

@property (weak, nonatomic) IBOutlet UILabel *goodsOldPrice1;
@property (weak, nonatomic) IBOutlet UILabel *goodsOldPrice2;

@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price2;

@property (weak, nonatomic) IBOutlet UIButton *buyButton1;
@property (weak, nonatomic) IBOutlet UIButton *buyButton2;

@end
