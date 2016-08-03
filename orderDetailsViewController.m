//
//  orderDetailsViewController.m
//  feichacha
//
//  Created by wt on 16/4/27.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "orderDetailsViewController.h"
#import "orderStateTableViewCell.h"
#import "orderDetailsTableViewCell.h"
#import "orderDetailsGoodsTableViewCell.h"
#import "orderDetailsFootTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
@interface orderDetailsViewController ()<UIActionSheetDelegate>
{
    BOOL stateOrDetails;
    NSString *OrderId;
    
    NSArray * Timelist;

}
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *orderStateButton;
@property (weak, nonatomic) IBOutlet UIButton *orderDetailsButton;

@property (weak, nonatomic) IBOutlet UIButton *footButton1;
@property (weak, nonatomic) IBOutlet UIButton *footButton2;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation orderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayer];
    stateOrDetails = YES;
    NSLog(@"%@",_getDatas);
    _footButton2.hidden = YES;
    switch ([[_getDatas objectForKey:@"State"]intValue]) {
        case 0:
            [_footButton1 setTitle:@"取消订单" forState:UIControlStateNormal];
            
            break;
        case 1:
            [_footButton1 setTitle:@"确定收货" forState:UIControlStateNormal];
            
            break;
        case 2:
            
            break;
        case 3:
            [_footButton1 setTitle:@"取消订单" forState:UIControlStateNormal];
            
            break;
        case 4:
            [_footButton1 setTitle:@"取消订单" forState:UIControlStateNormal];
            
            break;
        case 6:
            [_footButton1 setTitle:@"去支付" forState:UIControlStateNormal];
            _footButton2.hidden = NO;
            [_footButton2 setTitle:@"取消订单" forState:UIControlStateNormal];
            
            break;
        case 7:
            _footButton1.hidden = YES;
            
            break;
        default:
            break;
    }
    // Do any additional setup after loading the view.
    [self TimeList];
}

-(void)TimeList{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] TimeList:[_getDatas objectForKey:@"OrderId"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            Timelist = [responseObject objectForKey:@"AppendData"];
            [_tableView reloadData];
        }else {
            Timelist = nil;
            [_tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];

}
#pragma mark 联系商家
- (IBAction)leftButtonClick:(id)sender {
    [AppUtils callPhone:[_getDatas objectForKey:@"CompanyMobile"]];
}

#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* tempArray = [_getDatas objectForKey:@"OrderList"];
    if (stateOrDetails) {
        return Timelist.count;
    }else{
        return 2+tempArray.count;
    }
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (stateOrDetails) {
        return 70;
    }else{
        if (indexPath.row == 0) {
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
            CGSize titleSize =[[NSString stringWithFormat:@"%@ ",[_getDatas objectForKey:@"Remark"]]  boundingRectWithSize:CGSizeMake(SCREENWIDTH-84, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            return titleSize.height + 332;
        }else if (indexPath.row == 3){
            return 44;
        }else{
            return 35;
        }
        
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tempArray = [_getDatas objectForKey:@"OrderList"];
    if (stateOrDetails) {
        static NSString *cellIdentifier = @"orderStateTableViewCell";
        orderStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"orderStateTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0) {
            cell.line1.hidden = YES;
            [cell.roundImageView setImage:[UIImage imageNamed:@"yuan_1.png"]];
        }else if (indexPath.row == Timelist.count-1){
            cell.line2.hidden = YES;
        }
        switch ([[Timelist[indexPath.row] objectForKey:@"OptType"] intValue]) {
            case 0:
                cell.timeLbael.text = [Timelist[indexPath.row] objectForKey:@"OptDatetimes"];
                cell.message1.text = @"商家配送中～";
                cell.message2.text = @"配送中，我们跑的飞叉叉的...";
                break;
            case 1:
                cell.timeLbael.text = [Timelist[indexPath.row] objectForKey:@"OptDatetimes"];
                cell.message1.text = @"商品已送达";
                cell.message2.text = @"商品已送达";
                break;
            case 2:
                cell.timeLbael.text = [Timelist[indexPath.row] objectForKey:@"OptDatetimes"];
                cell.message1.text = @"用户确认收货";
                cell.message2.text = @"用户确认收货";
                break;
            case 3:
                cell.timeLbael.text = [Timelist[indexPath.row] objectForKey:@"OptDatetimes"];
                cell.message1.text = @"商家接单中...";
                cell.message2.text = @"商家接单中...";
                break;
            case 4:
                cell.timeLbael.text = [Timelist[indexPath.row] objectForKey:@"OptDatetimes"];
                cell.message1.text = @"正在配送";
                cell.message2.text = @"正在配送";
                break;
            case 6:
                cell.timeLbael.text = [Timelist[indexPath.row] objectForKey:@"OptDatetimes"];
                cell.message1.text = @"待支付";
                cell.message2.text = @"待支付";
                break;
            case 7:
                cell.timeLbael.text = [Timelist[indexPath.row] objectForKey:@"OptDatetimes"];
                cell.message1.text = @"订单已取消";
                cell.message2.text = @"订单已取消";
                break;
            case 8:
                cell.timeLbael.text = [Timelist[indexPath.row] objectForKey:@"OptDatetimes"];
                cell.message1.text = @"商家取消接单";
                cell.message2.text = @"商家取消接单";
                break;
            case 9:
                cell.timeLbael.text = [Timelist[indexPath.row] objectForKey:@"OptDatetimes"];
                cell.message1.text = @"申请退款中";
                cell.message2.text = @"申请退款中";
                break;
            case 10:
                cell.timeLbael.text = [Timelist[indexPath.row] objectForKey:@"OptDatetimes"];
                cell.message1.text = @"退款完成";
                cell.message2.text = @"退款完成";
                break;
            case 11:
                cell.timeLbael.text = [Timelist[indexPath.row] objectForKey:@"OptDatetimes"];
                cell.message1.text = @"退款失败";
                cell.message2.text = @"退款失败";
                break;
                
            default:
                break;
        }
        
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            static NSString *cellIdentifier = @"orderDetailsTableViewCell";
            orderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"orderDetailsTableViewCell" owner:self options:nil][0];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.orderNumber.text = [_getDatas objectForKey:@"OrderId"];
            cell.orderTime.text = [_getDatas objectForKey:@"AddDates"];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date5=[dateFormatter dateFromString:[_getDatas objectForKey:@"PresetEndTimes"]];
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"HH:mm:ss"];

//            NSLog(@"%@",[dateFormatter2 stringFromDate:date5]);
            cell.deliveryTime.text = [NSString stringWithFormat:@"%@-%@",[_getDatas objectForKey:@"PresetStartTimes"],[dateFormatter2 stringFromDate:date5]];

            
            cell.name.text = [_getDatas objectForKey:@"UserName"];
            cell.phoneNumber.text = [_getDatas objectForKey:@"Mobile"];
            cell.address.text = [_getDatas objectForKey:@"Address"];
            cell.shopName.text = [_getDatas objectForKey:@"CompanyName"];
            
            //DeliveryType 1送货上门 2到店自提
            if ([[_getDatas objectForKey:@"DeliveryType"] intValue] == 1) {
                cell.inDistribution.text = @"送货上门";
            }else{
                cell.inDistribution.text = @"到店自提";
            }
            
            //Type  1支付宝  2微信   4货到付款
            if ([[_getDatas objectForKey:@"Type"] intValue] == 1) {
                cell.payWay.text = @"支付宝支付";
            }else if([[_getDatas objectForKey:@"Type"] intValue] == 2){
                cell.payWay.text = @"微信支付";
            }else{
                cell.payWay.text = @"货到付款";
            }

            cell.note.text = [NSString stringWithFormat:@"%@ ",[_getDatas objectForKey:@"Remark"]];

            
            return cell;
        }else if (indexPath.row == tempArray.count+1){
            static NSString *cellIdentifier = @"orderDetailsFootTableViewCell";
            orderDetailsFootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"orderDetailsFootTableViewCell" owner:self options:nil][0];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            return cell;
        }else{
            static NSString *cellIdentifier = @"orderDetailsGoodsTableViewCell";
            orderDetailsGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"orderDetailsGoodsTableViewCell" owner:self options:nil][0];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.name.text = [tempArray[indexPath.row-1] objectForKey:@"ProductName"];
            cell.number.text = [NSString stringWithFormat:@"x%@",[tempArray[indexPath.row-1] objectForKey:@"ProductCount"]];
            cell.price.text = [NSString stringWithFormat:@"￥%.1f",[[tempArray[indexPath.row-1] objectForKey:@"ProductMoney"] floatValue]];

            return cell;
        }
       
    }
    
}
#pragma mark 底部button点击
- (IBAction)button1Click:(id)sender {
    if ([[_getDatas objectForKey:@"State"]intValue]==0 || [[_getDatas objectForKey:@"State"]intValue]==3 || [[_getDatas objectForKey:@"State"]intValue]==4 || [[_getDatas objectForKey:@"State"]intValue]==7) {
        NSLog(@"取消订单");
        [self ConfirmOrder:[_getDatas objectForKey:@"OrderId"] type:@"7"];
    }else if([[_getDatas objectForKey:@"State"]intValue] == 1){
        NSLog(@"确定收货");
        [self ConfirmOrder:[_getDatas objectForKey:@"OrderId"] type:@"2"];
    }else if([[_getDatas objectForKey:@"State"]intValue] == 6){
        NSLog(@"去支付");
        [USERDEFAULTS setObject:[_getDatas objectForKey:@"State"] forKey:@"OrderNumber"];
        
        OrderId = [_getDatas objectForKey:@"OrderId"];
        UIActionSheet *actionsheet =[[UIActionSheet alloc]initWithTitle:@"去支付" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信支付",@"支付宝支付", nil];
        actionsheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionsheet showInView:self.view];
    }
}
- (IBAction)button2Click:(id)sender {
    [self ConfirmOrder:[_getDatas objectForKey:@"OrderId"] type:@"7"];
}

#pragma mark 取消订单 7 ，确认收货  2
-(void)ConfirmOrder:(NSString *)orderID type:(NSString *)type{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSLog(@"%@",orderID);
    [[NetworkUtils shareNetworkUtils] ConfirmOrder:orderID Type:type success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            if ([type intValue] == 2) {
                [SVProgressHUD showSuccessWithStatus:@"确认收货成功"];
                [_tableView reloadData];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"订单已取消"];
                [_tableView reloadData];
            }
        }else {
            
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 订单状态
- (IBAction)orderStateClick:(id)sender {
    stateOrDetails = YES;
    _orderStateButton.backgroundColor = RGBCOLORA(255, 214, 0, 1);
    _orderDetailsButton.backgroundColor = [UIColor whiteColor];
    [_orderStateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_orderDetailsButton setTitleColor:RGBCOLORA(111, 111, 111, 1) forState:UIControlStateNormal];
    
    [_tableView reloadData];
}
#pragma mark 订单详情
- (IBAction)orderDetailsClick:(id)sender {
    stateOrDetails = NO;
    _orderDetailsButton.backgroundColor = RGBCOLORA(255, 214, 0, 1);
    _orderStateButton.backgroundColor = [UIColor whiteColor];
    [_orderDetailsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_orderStateButton setTitleColor:RGBCOLORA(111, 111, 111, 1) forState:UIControlStateNormal];
    
    [_tableView reloadData];
}
-(void)initLayer{
    _titleView.layer.cornerRadius = 4;
    _titleView.layer.masksToBounds = YES;
    _titleView.layer.borderWidth = 1;
    _titleView.layer.borderColor = RGBCOLORA(255, 214, 0, 1).CGColor;
    _footButton1.layer.cornerRadius = 4;
    _footButton2.layer.cornerRadius = 4;
    _leftButton.layer.cornerRadius = 4;

}
- (IBAction)backView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
