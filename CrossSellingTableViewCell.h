//
//  CrossSellingTableViewCell.h
//  feichacha
//
//  Created by wt on 16/4/24.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrossSellingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage1;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage2;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage3;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage4;

@property (weak, nonatomic) IBOutlet UILabel *goodsName1;               //商品名
@property (weak, nonatomic) IBOutlet UILabel *goodsName2;
@property (weak, nonatomic) IBOutlet UILabel *goodsName3;
@property (weak, nonatomic) IBOutlet UILabel *goodsName4;

@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe1_1;         //精，进，买一送一
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe1_2;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe1_3;

@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe2_1;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe2_2;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe2_3;

@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe3_1;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe3_2;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe3_3;

@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe4_1;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe4_2;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe4_3;

@property (weak, nonatomic) IBOutlet UILabel *goodsMessage1;            //商品信息
@property (weak, nonatomic) IBOutlet UILabel *goodsMessage2;
@property (weak, nonatomic) IBOutlet UILabel *goodsMessage3;
@property (weak, nonatomic) IBOutlet UILabel *goodsMessage4;

@property (weak, nonatomic) IBOutlet UILabel *goodsPrice1;              //商品价格
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice2;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice3;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice4;

@property (weak, nonatomic) IBOutlet UILabel *goodsOldPrice1;           //商品原价
@property (weak, nonatomic) IBOutlet UILabel *goodsOldPrice2;
@property (weak, nonatomic) IBOutlet UILabel *goodsOldPrice3;
@property (weak, nonatomic) IBOutlet UILabel *goodsOldPrice4;

@property (weak, nonatomic) IBOutlet UIButton *addShoppingCartButton1;  //加入购物车按钮
@property (weak, nonatomic) IBOutlet UIButton *addShoppingCartButton2;
@property (weak, nonatomic) IBOutlet UIButton *addShoppingCartButton3;
@property (weak, nonatomic) IBOutlet UIButton *addShoppingCartButton4;

@property (weak, nonatomic) IBOutlet UIButton *goodsButton1;            //商品点击按钮
@property (weak, nonatomic) IBOutlet UIButton *goodsButton2;
@property (weak, nonatomic) IBOutlet UIButton *goodsButton3;
@property (weak, nonatomic) IBOutlet UIButton *goodsButton4;

@property (weak, nonatomic) IBOutlet UIButton *allGoodsButton;

@end