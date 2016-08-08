//
//  submitOrdersViewController.m
//  feichacha
//
//  Created by wt on 16/5/5.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "submitOrdersViewController.h"
#import "submitOrderGoodsTableViewCell.h"
#import "submitOrderHeadView.h"
#import "submitOrderSectionHeadView.h"
#import "submitOrderSectionFootView.h"
#import "submitOrderFootView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "paymentStatusViewController.h"
#import "myOrderViewController.h"

@interface submitOrdersViewController ()<WXApiDelegate>
{
    submitOrderHeadView *headView;
    submitOrderFootView *footView;
    
    NSString *selectPay;
    
    NSMutableArray *Direct;
    NSMutableArray *notDirect;
    float dirMoney;
    float notDirMoney;
    id userLuck;
}
//@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *allPrice;
@property (weak, nonatomic) IBOutlet UIButton *toPayButton;

@end

@implementation submitOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.01f)];
    self.tableView.tableHeaderView = view;
    footView = [[NSBundle mainBundle] loadNibNamed:@"submitOrderFootView" owner:self options:nil][0];
    [footView setFrame:CGRectMake(0, 0, SCREENWIDTH, 157)];
    footView.shoppingFee.text = [NSString stringWithFormat:@"￥%1.f",[_getFreight floatValue]];
    self.tableView.tableFooterView = footView;
    selectPay = @"weChat";
    [self getUserLuck];
    
    Direct = [[NSMutableArray alloc]init];
    notDirect = [[NSMutableArray alloc]init];
    NSLog(@"%@",_getDatas);
    for (int i = 0; i<_getDatas.count; i++) {
        if (![[_getDatas[i] objectForKey:@"IsDirect"] boolValue] && [[_getDatas[i] allKeys] containsObject:@"IsDirect"]) {
            [Direct addObject:_getDatas[i]];
        }else{
            [notDirect addObject:_getDatas[i]];
        }
    }

    NSLog(@"%@",Direct);
    NSLog(@"%@",notDirect);

    // Do any additional setup after loading the view.
    dirMoney = 0;
    notDirMoney = 0;
    if (Direct.count != 0) {
        for (int i = 0; i<Direct.count; i++) {
            dirMoney += ([[Direct [i] objectForKey:@"PurchaseQuantity"] floatValue]*[[Direct [i] objectForKey:@"Price"] floatValue]);
            NSLog(@"%f",dirMoney);
        }
    }
    if (notDirect.count != 0) {
        for (int i = 0; i<notDirect.count; i++) {
            notDirMoney += ([[notDirect [i] objectForKey:@"PurchaseQuantity"] intValue]*[[notDirect [i] objectForKey:@"Price"] floatValue]);
        }
    }
    NSLog(@"%f",dirMoney);
    NSLog(@"%f",notDirMoney);

    footView.goodsTotalMoney.text = [NSString stringWithFormat:@"￥%.1f",dirMoney+notDirMoney];
    _allPrice.text = [NSString stringWithFormat:@"￥%.1f",dirMoney+notDirMoney+[_getFreight floatValue]];
    NSLog(@"%@",[USERDEFAULTS objectForKey:@"CurrentAddress"]);
}
-(void)getUserLuck{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] UserLucky:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            userLuck = [responseObject objectForKey:@"AppendData"];
        }else {
            userLuck = nil;
        }
        [_tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];

}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else {
        if (section == 1) {
            if ([self returnSituation] != 4 && [self returnSituation] != 2) {
                return  Direct.count;
            }else{
                return  notDirect.count;
            }
        }
        if (section == 2) {
            if ([self returnSituation] == 3 ||[self returnSituation] == 4 )  {
                return  1;
            }else{
                return  notDirect.count;
            }
        }
        if (section == 3) {
            if (userLuck != nil) {
                return 1;
            }
        }
    }
    return 0;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 35;
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"submitOrderGoodsTableViewCell";
    submitOrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"submitOrderGoodsTableViewCell" owner:self options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"%d",[self returnSituation]);
    if (indexPath.section == 1) {
        if ([self returnSituation] != 4 && [self returnSituation] != 2) {
            cell.goodsName.text = [Direct[indexPath.row] objectForKey:@"Name"];
            cell.goodsNumber.text = [NSString stringWithFormat:@"x%@",[Direct[indexPath.row] objectForKey:@"PurchaseQuantity"]];
            cell.goodsPrice.text = [NSString stringWithFormat:@"%.2f",[[Direct[indexPath.row] objectForKey:@"Price"] floatValue]];
        }else{
            cell.goodsName.text = [notDirect[indexPath.row] objectForKey:@"Name"];
            cell.goodsNumber.text = [NSString stringWithFormat:@"x%@",[notDirect[indexPath.row] objectForKey:@"PurchaseQuantity"]];
            cell.goodsPrice.text = [NSString stringWithFormat:@"%.2f",[[notDirect[indexPath.row] objectForKey:@"Price"] floatValue]];
            cell.goodsDescribe.hidden = YES;
        }
    }
    if (indexPath.section == 2) {
        if ([self returnSituation] == 3 ||[self returnSituation] == 4 )  {
            cell.goodsName.text = [userLuck objectForKey:@"LuckyProductName"];
            cell.goodsDescribe.hidden = YES;
            cell.goodsNumber.hidden = YES;
            cell.goodsPrice.text = @"x1";
        }else{
            cell.goodsName.text = [notDirect[indexPath.row] objectForKey:@"Name"];
            cell.goodsNumber.text = [NSString stringWithFormat:@"x%@",[notDirect[indexPath.row] objectForKey:@"PurchaseQuantity"]];
            cell.goodsPrice.text = [NSString stringWithFormat:@"%.2f",[[notDirect[indexPath.row] objectForKey:@"Price"] floatValue]];
            cell.goodsDescribe.hidden = YES;
        }
    }
    if (indexPath.section == 3) {
        if (userLuck != nil) {
            cell.goodsName.text = [userLuck objectForKey:@"LuckyProductName"];
            cell.goodsDescribe.hidden = YES;
            cell.goodsNumber.hidden = YES;
            cell.goodsPrice.text = @"x1";
        }
    }

    
    return cell;
}

#pragma mark 有几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self returnSituation] == 0) {
        return 1;
    }else if ([self returnSituation] == 1){
        return 2;
    }else if ([self returnSituation] == 2){
        return 2;
    }else if ([self returnSituation] == 3){
        return 3;
    }else if ([self returnSituation] == 4){
        return 3;
    }else if ([self returnSituation] == 5){
        return 3;
    }else  {
        return 4;
    }
}
#pragma mark 头有多高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 159;
    }else{
        return 35;
    }
}
#pragma mark 头内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        headView = [[NSBundle mainBundle] loadNibNamed:@"submitOrderHeadView" owner:self options:nil][0];
        [headView.couponsButton addTarget:self action:@selector(couponsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView.aliPayButton addTarget:self action:@selector(aliPayButton:) forControlEvents:UIControlEventTouchUpInside];
        [headView.weChatButton addTarget:self action:@selector(weChatButton:) forControlEvents:UIControlEventTouchUpInside];
        if ([_OrderType intValue] == 1) {
            [headView.CashOnDeliveryButton addTarget:self action:@selector(CashOnDeliveryButton:) forControlEvents:UIControlEventTouchUpInside];
            headView.toLabel.backgroundColor = [UIColor redColor];
            headView.CashOnDeliveryView.backgroundColor = [UIColor whiteColor];
            headView.CashOnDeliveryMessage.hidden = YES;
        }else{
            headView.CashOnDeliveryButton.userInteractionEnabled = YES;
            headView.toLabel.backgroundColor = RGBCOLORA(130, 130, 130, 1);
            headView.CashOnDeliveryView.backgroundColor = RGBCOLORA(239, 239, 239, 1);
            headView.CashOnDeliveryMessage.hidden = NO;
        }
        return headView;
    }else{
        submitOrderSectionHeadView *sectionHeadView = [[NSBundle mainBundle] loadNibNamed:@"submitOrderSectionHeadView" owner:self options:nil][0];

        if (section == 1) {
            if ([self returnSituation] != 4 && [self returnSituation] != 2) {
                sectionHeadView.name.text = @"叉叉精选";
            }else{
                sectionHeadView.name.text = @"其他商品";
            }
        }
        if (section == 2) {
            if ([self returnSituation] == 3 ||[self returnSituation] == 4 )  {
                sectionHeadView.name.text = @"中奖商品";
            }else{
                sectionHeadView.name.text = @"其他商品";
            }
        }
        if (section == 3) {
            sectionHeadView.name.text = @"中奖商品";
        }
        
        return sectionHeadView;
    }

}
#pragma mark 底部有多高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }else if(section == 4 || section == 3){
        return 0.001;
    }else{
        return 45;
    }
}
#pragma mark 底部内容
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    submitOrderSectionFootView *sectionFootView = [[NSBundle mainBundle] loadNibNamed:@"submitOrderSectionFootView" owner:self options:nil][0];
    
    
    if (section == 0) {
        return nil;
    }else if(section == 3){
        return nil;
    }else{
        if (section == 1) {
            if ([self returnSituation] != 4 && [self returnSituation] != 2) {
                sectionFootView.allPrice.text = [NSString stringWithFormat:@"￥%.1f",dirMoney];
            }else{
                sectionFootView.allPrice.text = [NSString stringWithFormat:@"￥%.1f",notDirMoney];
            }
        }
        if (section == 2) {
            if ([self returnSituation] == 3 ||[self returnSituation] == 4 ) {
                sectionFootView.allPrice.text = [NSString stringWithFormat:@"￥0.0"];
            }else{
                sectionFootView.allPrice.text = [NSString stringWithFormat:@"￥%.1f",notDirMoney];
            }
        }
               return sectionFootView;
    }
}
#pragma mark 跳转优惠卷
-(void)couponsButtonClick:(UIButton *)sender{
    [self performSegueWithIdentifier:@"submitOrdersToCoupons" sender:self];
}
-(void)aliPayButton:(UIButton *)sender{
    selectPay = @"aliPay";
    [headView.weChatButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [headView.aliPayButton setImage:[UIImage imageNamed:@"radio_x"] forState:UIControlStateNormal];
    [headView.CashOnDeliveryButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
}
-(void)weChatButton:(UIButton *)sender{
    selectPay = @"weChat";
    [headView.weChatButton setImage:[UIImage imageNamed:@"radio_x"] forState:UIControlStateNormal];
    [headView.aliPayButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [headView.CashOnDeliveryButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
}
-(void)CashOnDeliveryButton:(UIButton *)sender{
    selectPay = @"CashOnDelivery";
    [headView.weChatButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [headView.aliPayButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    [headView.CashOnDeliveryButton setImage:[UIImage imageNamed:@"radio_x"] forState:UIControlStateNormal];
}

-(int)returnSituation{
    //0都没有
    //1有精
    //2有其他
    //3有精和奖品
    //4有其他和奖品
    //5有精和其他
    //6都有
    if(userLuck == nil && Direct.count == 0 && notDirect.count == 0){
        return 0;
    }else if(userLuck == nil&& Direct.count != 0 && notDirect.count == 0){
        return 1;
    }else if(userLuck == nil&& Direct.count == 0 && notDirect.count != 0){
        return 2;
    }else if(userLuck != nil&& Direct.count != 0 && notDirect.count == 0){
        return 3;
    }else if (userLuck != nil&& Direct.count == 0 && notDirect.count != 0){
        return 4;
    }else if (userLuck == nil&& Direct.count != 0 && notDirect.count != 0){
        return 5;
    }else{
        return 6;
    }
}
- (IBAction)toPay:(id)sender {
//    NSString* date;
//    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
//    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
//    date = [formatter stringFromDate:[NSDate date]];
//    NSString* timeNow = [[NSString alloc] initWithFormat:@"%@", date];
//    NSLog(@"开始支付=======%@", timeNow);
    _toPayButton.userInteractionEnabled = NO;
    headView.aliPayButton.userInteractionEnabled = NO;
    headView.weChatButton.userInteractionEnabled = NO;
    headView.CashOnDeliveryButton.userInteractionEnabled = NO;
    
    NSString* tempStr;
    if ([selectPay isEqualToString:@"aliPay"]) {
        tempStr = @"1";
    }
    if ([selectPay isEqualToString:@"weChat"]) {
        tempStr = @"2";
    }
    if ([selectPay isEqualToString:@"CashOnDelivery"]) {
        tempStr = @"4";
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<_getDatas.count; i++) {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        [tempDic setObject:[_getDatas[i] objectForKey:@"Fguid"] forKey:@"ProductId"];
        [tempDic setObject:[_getDatas[i] objectForKey:@"PurchaseQuantity"] forKey:@"ProductCount"];
        [tempDic setObject:[NSString stringWithFormat:@"%.2f",[[_getDatas[i] objectForKey:@"Price"] floatValue]] forKey:@"ProductMoney"];
        [tempArray addObject:tempDic];
    }
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] SubmitOrder:[USERDEFAULTS objectForKey:@"UserID"] CompanyId:[USERDEFAULTS objectForKey:@"shopID"] Type:tempStr CouponId:@"0" IsCoupon:@"false" AddId:[[USERDEFAULTS objectForKey:@"delectDetailedAddress"] objectForKey:@"Id"] Remark:_Remark OrderType:_OrderType PresetStartTime:_time OrderList:tempArray DeliveryType:[USERDEFAULTS objectForKey:@"DeliveryType"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
//        NSString* date;
//        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
//        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
//        date = [formatter stringFromDate:[NSDate date]];
//        NSString* timeNow = [[NSString alloc] initWithFormat:@"%@", date];
//        NSLog(@"得到订单号=======%@", timeNow);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            if ([_OrderType intValue ] == 1) {
                for (int i = 0; i<_getDatas.count; i++) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsDelete" object:_getDatas[i]];
                }
            }else{
                for (int i = 0; i<_getDatas.count; i++) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReservationShoppingCartGoodsDelete" object:_getDatas[i]];
                }
            }
            
            [USERDEFAULTS setObject:[[responseObject objectForKey:@"AppendData"] objectForKey:@"orderId"] forKey:@"OrderNumber"];
            if ([selectPay isEqualToString:@"aliPay"]) {
                [self PayDes:[[responseObject objectForKey:@"AppendData"] objectForKey:@"orderId"] Type:@"1"];
            }
            if ([selectPay isEqualToString:@"weChat"]) {
                [self WxPayDes:[[responseObject objectForKey:@"AppendData"] objectForKey:@"orderId"]];
            }
            if ([selectPay isEqualToString:@"CashOnDelivery"]) {
                UIStoryboard *stroyBoard = GetStoryboard(@"Main");
                myOrderViewController *myOrderVC = [stroyBoard instantiateViewControllerWithIdentifier:@"myOrderViewController"];
                [myOrderVC setOrderType:@"allOrder"];
                [self.navigationController pushViewController:myOrderVC animated:YES];
            }
        }else {
            userLuck = nil;
        }
        [_tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
-(void)PayDes:(NSString *)Order Type:(NSString *)Type{
    _toPayButton.userInteractionEnabled = NO;
    headView.aliPayButton.userInteractionEnabled = NO;
    headView.weChatButton.userInteractionEnabled = NO;
    headView.CashOnDeliveryButton.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] PayDes:Order Type:Type success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            if ([selectPay isEqualToString:@"aliPay"]) {
                NSString *tempStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)[[responseObject objectForKey:@"AppendData"] objectForKey:@"sign"], nil, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",[[responseObject objectForKey:@"AppendData"] objectForKey:@"biz_content"], tempStr, @"RSA"];
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"feichacha" callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                    }];
            }
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"订单提交错误，请重试"];
        }
        [_tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];

}
-(void)WxPayDes:(NSString *)order{
    _toPayButton.userInteractionEnabled = NO;
    headView.aliPayButton.userInteractionEnabled = NO;
    headView.weChatButton.userInteractionEnabled = NO;
    headView.CashOnDeliveryButton.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] WxPayDes:order success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
//        NSString* date;
//        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
//        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
//        date = [formatter stringFromDate:[NSDate date]];
//        NSString* timeNow = [[NSString alloc] initWithFormat:@"%@", date];
//        NSLog(@"得到支付码开始微信=======%@", timeNow);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
                PayReq* req       = [[PayReq alloc] init];
                req.partnerId     = [[responseObject objectForKey:@"AppendData"] objectForKey:@"partnerId"];
                req.prepayId      = [[responseObject objectForKey:@"AppendData"] objectForKey:@"prepayId"];
                req.nonceStr      = [[responseObject objectForKey:@"AppendData"] objectForKey:@"nonceStr"];
                req.timeStamp     = [[[responseObject objectForKey:@"AppendData"] objectForKey:@"timestamp"] intValue];
                req.package       = [[responseObject objectForKey:@"AppendData"] objectForKey:@"packageValue"];
                req.sign          = [[responseObject objectForKey:@"AppendData"] objectForKey:@"sign"];
                
                [WXApi sendReq:req];
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"订单提交错误，请重试"];
        }
        [_tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)backView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
