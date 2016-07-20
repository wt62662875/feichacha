//
//  shoppingCartHeadView.h
//  feichacha
//
//  Created by wt on 16/4/28.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shoppingCartHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIImageView *flashImage;               //闪 图片
@property (weak, nonatomic) IBOutlet UIButton *flashButton;                 //闪送小超按钮
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;               //箭头
@property (weak, nonatomic) IBOutlet UIButton *togetherButton;              //凑单
@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UILabel *theRulesLbael;                //规则
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;                   //收货时间Label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;                  //收货时间按钮

@property (weak, nonatomic) IBOutlet UITextField *noteTextField;                //备注

@end
