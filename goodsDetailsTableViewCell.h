//
//  goodsDetailsTableViewCell.h
//  feichacha
//
//  Created by wt on 16/5/6.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goodsDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsName;                    //名字
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;                   //价格
@property (weak, nonatomic) IBOutlet UILabel *goodsOldPrice;                //原价

@property (weak, nonatomic) IBOutlet UILabel *SalesPromotion1;              //促销1
@property (weak, nonatomic) IBOutlet UILabel *SalesPromotion2;              //促销2

@property (weak, nonatomic) IBOutlet UILabel *goodsBrand;                   //品牌
@property (weak, nonatomic) IBOutlet UILabel *goodsSpecifications;          //规格
@property (weak, nonatomic) IBOutlet UILabel *shelfLife;                    //保质期

@end
