//
//  wineCollectionViewCell.h
//  feichacha
//
//  Created by wt on 16/5/16.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wineCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *specifications;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *goodsClick;

@end
