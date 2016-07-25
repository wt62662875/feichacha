//
//  submitOrdersViewController.h
//  feichacha
//
//  Created by wt on 16/5/5.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface submitOrdersViewController : UIViewController
@property (weak, nonatomic) NSArray* getDatas;
@property (weak, nonatomic) NSString* getFreight;
@property (weak, nonatomic) NSString* OrderType;
@property (weak, nonatomic) NSString* Remark;
@property (weak, nonatomic) NSString* time;

/**
 *  设置失败界面
 */
-(void) setFalseFor_Pay;
/**
 *  设置成功界面
 */
-(void) setSuccessFor_pay;
@end
