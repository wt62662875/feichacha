//
//  submitOrderFootView.h
//  feichacha
//
//  Created by wt on 16/5/5.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface submitOrderFootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalMoney;      //商品总额
@property (weak, nonatomic) IBOutlet UILabel *shoppingFee;          //配送费
@property (weak, nonatomic) IBOutlet UILabel *serviceFee;           //服务费
@property (weak, nonatomic) IBOutlet UILabel *coupons;              //优惠卷

@end
