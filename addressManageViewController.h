//
//  addressManageViewController.h
//  feichacha
//
//  Created by wt on 16/4/26.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol positioningDelegate <NSObject>

- (void)positioningBackView:(NSString *)sender; //0定位当前  1选择门店    2自提

@end

@interface addressManageViewController : UIViewController

@property (strong, nonatomic) NSString *whereToHere;

@property (nonatomic, assign) id <positioningDelegate> delegate;


@property (strong, nonatomic) id sendDatas;


@end
