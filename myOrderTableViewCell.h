//
//  myOrderTableViewCell.h
//  feichacha
//
//  Created by wt on 16/4/27.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *footButtonView;            //底部VIEW  是否隐藏

@property (weak, nonatomic) IBOutlet UILabel *timeLbael;                //时间
@property (weak, nonatomic) IBOutlet UILabel *statelabel;               //状态

@property (weak, nonatomic) IBOutlet UIImageView *image1;               //图片
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *iamge5;

@property (weak, nonatomic) IBOutlet UILabel *goodsNumberLabel;         //商品数量
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;               //价格

@property (weak, nonatomic) IBOutlet UIButton *footButton;              //底部按钮
@property (weak, nonatomic) IBOutlet UIButton *footButton2;

@end
