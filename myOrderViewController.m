//
//  myOrderViewController.m
//  feichacha
//
//  Created by wt on 16/4/27.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "myOrderViewController.h"
#import "myOrderTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "orderDetailsViewController.h"

@interface myOrderViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *redLine;

    NSArray *datas;
    
    NSString *OrderId;
    id sendDatas;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation myOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSlidingLine];
    // Do any additional setup after loading the view.
}
-(void)getDatas:(NSString *)type{
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] OrderList:type success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            datas = [responseObject objectForKey:@"AppendData"];
            [_tableView reloadData];
        }else {
            datas = nil;
            [_tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return datas.count;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[datas[indexPath.row] objectForKey:@"State"]intValue]== 2 || [[datas[indexPath.row] objectForKey:@"State"]intValue]== 7 ) {
        return 146;
    }else{
        return 187;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myOrderTableViewCell";
    myOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"myOrderTableViewCell" owner:self options:nil][0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    NSArray *tempArray = [datas[indexPath.row] objectForKey:@"OrderList"];
    if (tempArray.count == 1) {
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][0]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    }else if(tempArray.count == 2){
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][0]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][1]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    }else if(tempArray.count == 3){
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][0]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][1]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][2]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    }else if(tempArray.count == 4){
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][0]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][1]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][2]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][3]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    }else{
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][0]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][1]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][2]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.image4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][3]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.iamge5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[datas[indexPath.row] objectForKey:@"OrderList"][4]objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
    }
    cell.footButton2.hidden = YES;

    //0未配送 1配送完成 2确认收货 3未接单 4正在配送 6未支付 7取消订单
    switch ([[datas[indexPath.row] objectForKey:@"State"]intValue]) {
        case 0:
            cell.statelabel.text = @"待发货";
            [cell.footButton setTitle:@"取消订单" forState:UIControlStateNormal];

            break;
        case 1:
            cell.statelabel.text = @"已发货";
            [cell.footButton setTitle:@"确定收货" forState:UIControlStateNormal];
            
            break;
        case 2:
            cell.statelabel.text = @"订单完成";
            cell.footButtonView.hidden = YES;

            break;
        case 3:
            cell.statelabel.text = @"商家接单中...";
            [cell.footButton setTitle:@"取消订单" forState:UIControlStateNormal];

            break;
        case 4:
            cell.statelabel.text = @"配送中...";
            [cell.footButton setTitle:@"取消订单" forState:UIControlStateNormal];

            break;
        case 6:
            cell.statelabel.text = @"未支付";
            [cell.footButton setTitle:@"去支付" forState:UIControlStateNormal];
            cell.footButton2.hidden = NO;
            [cell.footButton2 setTitle:@"取消订单" forState:UIControlStateNormal];

            break;
        case 7:
            cell.statelabel.text = @"已取消";
            cell.footButtonView.hidden = YES;

            break;
        default:
            break;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *dateFormatted = [dateFormatter dateFromString:[datas[indexPath.row] objectForKey:@"AddDate"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *locationTimeString=[dateFormatter stringFromDate:dateFormatted];
    cell.timeLbael.text = locationTimeString;
    
    
    cell.goodsNumberLabel.text = [NSString stringWithFormat:@"共计%lu件商品",(unsigned long)tempArray.count];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.1f",[[datas[indexPath.row] objectForKey:@"Money"] floatValue]];
    
    cell.footButton.tag = indexPath.row;
    cell.footButton2.tag = indexPath.row;
    [cell.footButton addTarget:self action:@selector(footButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.footButton2 addTarget:self action:@selector(footButton2:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    sendDatas = datas[indexPath.row];
    [self performSegueWithIdentifier:@"myOrderToOrderDetails" sender:self];
}

#pragma mark 底部按钮
-(void)footButton:(UIButton *)sender{
    if ([[datas[sender.tag] objectForKey:@"State"]intValue]==0 || [[datas[sender.tag] objectForKey:@"State"]intValue]==3 || [[datas[sender.tag] objectForKey:@"State"]intValue]==4 || [[datas[sender.tag] objectForKey:@"State"]intValue]==7) {
        NSLog(@"取消订单");
        [self ConfirmOrder:[datas[sender.tag] objectForKey:@"OrderId"] type:@"7"];
    }else if([[datas[sender.tag] objectForKey:@"State"]intValue] == 1){
        NSLog(@"确定收货");
        [self ConfirmOrder:[datas[sender.tag] objectForKey:@"OrderId"] type:@"2"];
    }else if([[datas[sender.tag] objectForKey:@"State"]intValue] == 6){
        NSLog(@"去支付");
        [USERDEFAULTS setObject:[datas[sender.tag] objectForKey:@"OrderId"] forKey:@"OrderNumber"];

        OrderId = [datas[sender.tag] objectForKey:@"OrderId"];
        UIActionSheet *actionsheet =[[UIActionSheet alloc]initWithTitle:@"去支付" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信支付",@"支付宝支付", nil];
        actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionsheet showInView:self.view];
    }
}
-(void)footButton2:(UIButton *)sender{
    NSLog(@"取消订单%ld",(long)sender.tag);
    [self ConfirmOrder:[datas[sender.tag] objectForKey:@"OrderId"] type:@"7"];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [SVProgressHUD showWithStatus:@"加载中..."];
        [[NetworkUtils shareNetworkUtils] WxPayDes:OrderId success:^(id responseObject) {
            NSLog(@"数据:%@",responseObject);
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
                
            }
            [_tableView reloadData];
            [SVProgressHUD dismiss];
        } failure:^(NSString *error) {
            [SVProgressHUD dismiss];
        }];
    }else if (buttonIndex == 1){
        [SVProgressHUD showWithStatus:@"加载中..."];
        [[NetworkUtils shareNetworkUtils] PayDes:OrderId Type:@"1" success:^(id responseObject) {
            NSLog(@"数据:%@",responseObject);
            if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
                    NSString *tempStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)[[responseObject objectForKey:@"AppendData"] objectForKey:@"sign"], nil, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
                    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",[[responseObject objectForKey:@"AppendData"] objectForKey:@"biz_content"], tempStr, @"RSA"];
                    
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"feichacha" callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                    }];
                
            }else {
                
            }
            [_tableView reloadData];
            [SVProgressHUD dismiss];
        } failure:^(NSString *error) {
            [SVProgressHUD dismiss];
        }];
    }
}
#pragma mark 取消订单 7 ，确认收货  2
-(void)ConfirmOrder:(NSString *)orderID type:(NSString *)type{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] ConfirmOrder:orderID Type:type success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            if ([type intValue] == 2) {
                [SVProgressHUD showSuccessWithStatus:@"确认收货成功"];
                [self getDatas:@"0"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"订单已取消"];
                [self getDatas:@"0"];
            }
        }else {
            
        }
//        [_tableView reloadData];
//        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}


#pragma mark 全部订单
- (IBAction)allOrderClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8-30, 106, 60, 2);
    }completion:^(BOOL finished) {
        [self getDatas:@"0"];
    }];
}
#pragma mark 待付款订单
- (IBAction)obligationOrderClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8*3-30, 106, 60, 2);
    }completion:^(BOOL finished) {
        [self getDatas:@"1"];
    }];
}
#pragma mark 待收货订单
- (IBAction)ForTheGoodsOrderClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8*5-30, 106, 60, 2);
    }completion:^(BOOL finished) {
        [self getDatas:@"2"];
    }];
}
#pragma mark 待评价订单
- (IBAction)ToEvaluateOrderClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        redLine.layer.frame = CGRectMake(SCREENWIDTH/8*7-30, 106, 60, 2);
    }completion:^(BOOL finished) {
        [self getDatas:@"3"];
    }];
}
#pragma mark 初始化滑动线
-(void)initSlidingLine{
    redLine = [[UIView alloc]init];
    if ([_orderType isEqualToString:@"allOrder"]) {
        [redLine setFrame:CGRectMake(SCREENWIDTH/8-30, 106, 60, 2)];
        [self getDatas:@"0"];
    }else if ([_orderType isEqualToString:@"obligationOrder"]) {
        [redLine setFrame:CGRectMake(SCREENWIDTH/8*3-30, 106, 60, 2)];
        [self getDatas:@"1"];
    }if ([_orderType isEqualToString:@"ForTheGoodsOrder"]) {
        [redLine setFrame:CGRectMake(SCREENWIDTH/8*5-30, 106, 60, 2)];
        [self getDatas:@"2"];
    }if ([_orderType isEqualToString:@"ToEvaluateOrder"]) {
        [redLine setFrame:CGRectMake(SCREENWIDTH/8*7-30, 106, 60, 2)];
        [self getDatas:@"3"];
    }
    redLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:redLine];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"myOrderToOrderDetails"]) {
        orderDetailsViewController *orderDetailsVC = segue.destinationViewController;
        [orderDetailsVC setGetDatas:sendDatas];
    }
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
