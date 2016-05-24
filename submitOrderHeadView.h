//
//  submitOrderHeadView.h
//  feichacha
//
//  Created by wt on 16/5/5.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface submitOrderHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *weChatButton;                //选微信
@property (weak, nonatomic) IBOutlet UIButton *aliPayButton;                //选支付宝

@property (weak, nonatomic) IBOutlet UIView *CashOnDeliveryView;            //货到付款VIEW
@property (weak, nonatomic) IBOutlet UIButton *CashOnDeliveryButton;        //货到付款BUTTON
@property (weak, nonatomic) IBOutlet UILabel *CashOnDeliveryMessage;        //货到付款MESSAGE
@property (weak, nonatomic) IBOutlet UILabel *toLabel;                      //货到付款   “货”  字

@property (weak, nonatomic) IBOutlet UILabel *couponsMessage;               //优惠卷信息
@property (weak, nonatomic) IBOutlet UIButton *couponsButton;               //跳转优惠卷


@end
