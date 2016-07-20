//
//  shoppingCartAddressTableViewCell.h
//  feichacha
//
//  Created by wt on 16/4/28.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shoppingCartAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UIButton *addressManage;

@property (weak, nonatomic) IBOutlet UILabel *hiddenLabel1;
@property (weak, nonatomic) IBOutlet UILabel *hiddenLabel2;
@property (weak, nonatomic) IBOutlet UILabel *hiddenLabel3;
@property (weak, nonatomic) IBOutlet UILabel *hiddenLabel4;
@property (weak, nonatomic) IBOutlet UILabel *hiddenLabel5;
@property (weak, nonatomic) IBOutlet UILabel *hiddenLabel6;


@end
