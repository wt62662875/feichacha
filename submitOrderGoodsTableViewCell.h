//
//  submitOrderGoodsTableViewCell.h
//  feichacha
//
//  Created by wt on 16/5/5.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface submitOrderGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe;            //标签
@property (weak, nonatomic) IBOutlet UILabel *goodsName;                //名字
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;               //价格
@property (weak, nonatomic) IBOutlet UILabel *goodsNumber;              //数量

@end
