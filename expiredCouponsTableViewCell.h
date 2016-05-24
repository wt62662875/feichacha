//
//  expiredCouponsTableViewCell.h
//  feichacha
//
//  Created by wt on 16/4/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface expiredCouponsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roundViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkReasonButtonLeft;

@property (weak, nonatomic) IBOutlet UIView *roundView;

@property (weak, nonatomic) IBOutlet UIButton *checkReasonButton;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label1X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label3Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line3Width;

@end
