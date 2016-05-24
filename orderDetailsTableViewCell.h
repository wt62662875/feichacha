//
//  orderDetailsTableViewCell.h
//  feichacha
//
//  Created by wt on 16/4/27.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNumber;                      //订单号
@property (weak, nonatomic) IBOutlet UILabel *orderTime;                        //下单时间
@property (weak, nonatomic) IBOutlet UILabel *deliveryTime;                     //送货时间
@property (weak, nonatomic) IBOutlet UILabel *inDistribution;                   //配送方式
@property (weak, nonatomic) IBOutlet UILabel *payWay;                           //支付方式
@property (weak, nonatomic) IBOutlet UILabel *note;                             //备注

@property (weak, nonatomic) IBOutlet UILabel *name;                             //收货人
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;                      //电话
@property (weak, nonatomic) IBOutlet UILabel *address;                          //收货地址

@property (weak, nonatomic) IBOutlet UILabel *shopName;                         //配送店铺
@end
