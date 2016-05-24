//
//  freshBookingTableViewCell.h
//  feichacha
//
//  Created by wt on 16/5/22.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface freshBookingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *name3;

@property (weak, nonatomic) IBOutlet UILabel *message1;
@property (weak, nonatomic) IBOutlet UILabel *message2;
@property (weak, nonatomic) IBOutlet UILabel *message3;

@property (weak, nonatomic) IBOutlet UILabel *specifications1;
@property (weak, nonatomic) IBOutlet UILabel *specifications2;
@property (weak, nonatomic) IBOutlet UILabel *specifications3;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage1;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage2;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage3;

@property (weak, nonatomic) IBOutlet UIButton *bannerButton;
@property (weak, nonatomic) IBOutlet UIButton *goodsButton1;
@property (weak, nonatomic) IBOutlet UIButton *goodsButton2;
@property (weak, nonatomic) IBOutlet UIButton *goodsButton3;

@end
