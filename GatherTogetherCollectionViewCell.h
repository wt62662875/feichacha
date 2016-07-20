//
//  GatherTogetherCollectionViewCell.h
//  feichacha
//
//  Created by wt on 16/4/28.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GatherTogetherCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;               //商品名

@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe1;         //精，进，买一送一
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe2;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe3;

@property (weak, nonatomic) IBOutlet UILabel *goodsMessage1;            //商品信息

@property (weak, nonatomic) IBOutlet UILabel *goodsPrice1;              //商品价格

@property (weak, nonatomic) IBOutlet UILabel *goodsOldPrice1;           //商品原价

@property (weak, nonatomic) IBOutlet UIButton *addShoppingCartButton1;  //加入购物车按钮
@property (weak, nonatomic) IBOutlet UIButton *goodsClick;

@end
