//
//  paymentStatusViewController.m
//  feichacha
//
//  Created by wt on 16/7/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "paymentStatusViewController.h"
#import "myOrderViewController.h"

@interface paymentStatusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;

@end

@implementation paymentStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_payState intValue] == 1) {
        _titleLabel.text = @"支付成功";
        _orderNumberLabel.text = [NSString stringWithFormat:@"您的订单（%@）已支付成功！",[USERDEFAULTS objectForKey:@"OrderNumber"]];
        [_image setImage:[UIImage imageNamed:@"paySuccess"]];
    }else{
        _titleLabel.text = @"支付失败";
        _orderNumberLabel.text = [NSString stringWithFormat:@"您的订单（%@）支付失败了！",[USERDEFAULTS objectForKey:@"OrderNumber"]];
        [_image setImage:[UIImage imageNamed:@"payFalse"]];
    }
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)myOrder:(id)sender {
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    myOrderViewController *myOrderVC = [stroyBoard instantiateViewControllerWithIdentifier:@"myOrderViewController"];
    [myOrderVC setOrderType:@"allOrder"];
    [self.navigationController pushViewController:myOrderVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backView:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
