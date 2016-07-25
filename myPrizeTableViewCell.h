//
//  myPrizeTableViewCell.h
//  feichacha
//
//  Created by wt on 16/7/24.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myPrizeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roundViewLeft;

@property (weak, nonatomic) IBOutlet UIView *roundView;


@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label1X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label3Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line3Width;

@property (weak, nonatomic) IBOutlet UILabel *smallNumber;
@property (weak, nonatomic) IBOutlet UILabel *bigNumber;
@property (weak, nonatomic) IBOutlet UILabel *canUse;
@property (weak, nonatomic) IBOutlet UILabel *overdue;
@end
