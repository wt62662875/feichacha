//
//  personalCenterViewController.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "personalCenterViewController.h"
#import "myOrderViewController.h"
#import "addressManageViewController.h"

@interface personalCenterViewController ()<UIActionSheetDelegate>
{
    NSString *sendOrderType;
}
@property (weak, nonatomic) IBOutlet UILabel *obligationNumberLabel;            //待付款小圆点
@property (weak, nonatomic) IBOutlet UILabel *forTheGoodsNumberLabel;           //待收货小圆点
@property (weak, nonatomic) IBOutlet UILabel *ToEvaluateNumberLabel;            //待评价小圆点
@property (weak, nonatomic) IBOutlet UILabel *afterSalesNumberLabel;            //退款/售后小圆点

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@end

@implementation personalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNumberRound];
    _phoneNumber.text = [USERDEFAULTS objectForKey:@"telPhoneNumber"];
    // Do any additional setup after loading the view.
//    _forTheGoodsNumberLabel.hidden = YES;
}

#pragma mark 全部订单
- (IBAction)allOrderClick:(id)sender {
    sendOrderType = @"allOrder";
    [self performSegueWithIdentifier:@"personalCenterToMyOrder" sender:self];
}

#pragma mark 待付款订单
- (IBAction)obligationClick:(id)sender {
    sendOrderType = @"obligationOrder";
    [self performSegueWithIdentifier:@"personalCenterToMyOrder" sender:self];
}

#pragma mark 待收货订单
- (IBAction)ForTheGoodsClick:(id)sender {
    sendOrderType = @"ForTheGoodsOrder";
    [self performSegueWithIdentifier:@"personalCenterToMyOrder" sender:self];
}

#pragma mark 待评价订单
- (IBAction)ToEvaluateClick:(id)sender {
    sendOrderType = @"ToEvaluateOrder";
    [self performSegueWithIdentifier:@"personalCenterToMyOrder" sender:self];
}

#pragma mark 退款/售后
- (IBAction)afterSalesClick:(id)sender {
    [self performSegueWithIdentifier:@"personalCenterToAfterSales" sender:self];
}
#pragma mark 分享
- (IBAction)shareClick:(id)sender {
    UIActionSheet *actionsheet =[[UIActionSheet alloc]initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ空间", nil];
    actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionsheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"微信好友");
    }else if (buttonIndex == 1){
        NSLog(@"微信朋友圈");
    }else if (buttonIndex == 2){
        NSLog(@"新浪微博");
    }else if (buttonIndex == 3){
        NSLog(@"QQ空间");
    }
}
#pragma mark 初始化小圆点
-(void)initNumberRound{
    _obligationNumberLabel.layer.borderWidth = 1;
    _obligationNumberLabel.layer.borderColor = [UIColor redColor].CGColor;
    _obligationNumberLabel.layer.cornerRadius = 8;
    
    _forTheGoodsNumberLabel.layer.borderWidth = 1;
    _forTheGoodsNumberLabel.layer.borderColor = [UIColor redColor].CGColor;
    _forTheGoodsNumberLabel.layer.cornerRadius = 8;
    
    _ToEvaluateNumberLabel.layer.borderWidth = 1;
    _ToEvaluateNumberLabel.layer.borderColor = [UIColor redColor].CGColor;
    _ToEvaluateNumberLabel.layer.cornerRadius = 8;
    
    _afterSalesNumberLabel.layer.borderWidth = 1;
    _afterSalesNumberLabel.layer.borderColor = [UIColor redColor].CGColor;
    _afterSalesNumberLabel.layer.cornerRadius = 8;
    
    _obligationNumberLabel.hidden = YES;
    _forTheGoodsNumberLabel.hidden = YES;
    _ToEvaluateNumberLabel.hidden = YES;
    _afterSalesNumberLabel.hidden = YES;
}
#pragma mark 收货地址
- (IBAction)address:(id)sender {
    [self performSegueWithIdentifier:@"personalCenterToAddress" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"personalCenterToMyOrder"]) {
        myOrderViewController *myOrderVC = segue.destinationViewController;
        [myOrderVC setOrderType:sendOrderType];
    }else if ([segue.identifier isEqualToString:@"personalCenterToAddress"]) {
        addressManageViewController *addressManageVC = segue.destinationViewController;
        [addressManageVC setWhereToHere:@"perasonalCenter"];
    }
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
