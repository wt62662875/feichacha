//
//  flashGoodsTableViewCell.h
//  feichacha
//
//  Created by wt on 16/4/24.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface flashGoodsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;               //商品名
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe;         //精，进，买一送一
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe2;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe3;
@property (weak, nonatomic) IBOutlet UILabel *goodsMessage;            //商品信息
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;              //商品价格
@property (weak, nonatomic) IBOutlet UILabel *goodsOldPrice;           //商品原价
@property (weak, nonatomic) IBOutlet UIButton *addShoppingCartButton;  //加入购物车按钮
@property (weak, nonatomic) IBOutlet UIButton *minShoppingCartButton;  //减
@property (weak, nonatomic) IBOutlet UILabel *numberLbael;             //数量


@end
