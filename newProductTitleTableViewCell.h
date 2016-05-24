//
//  newProductTitleTableViewCell.h
//  feichacha
//
//  Created by wt on 16/5/8.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newProductTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *message1;
@property (weak, nonatomic) IBOutlet UILabel *message2;
@property (weak, nonatomic) IBOutlet UILabel *message3;

@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@end
