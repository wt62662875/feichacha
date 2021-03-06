//
//  shoppingCartViewController.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "shoppingCartViewController.h"
#import "shoppingCartGoodsTableViewCell.h"
#import "shoppingCartHeadView.h"
#import "shoppingCartFootView.h"
#import "shoppingCartAddressTableViewCell.h"
#import "VerifyTheMobilePhoneViewController.h"
#import "GatherTogetherASingleViewController.h"
#import "submitOrdersViewController.h"
#import "NewDatePicker.h"

@interface shoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource,NewPickDateViewDelegate>
{
    shoppingCartHeadView *headView;
    shoppingCartFootView *footView;
    NSMutableArray* FlashShoppingCartGoodsDatas;
    NSMutableArray* FlashShoppingCartGoodsBeforeDatas;
    NSMutableArray* FlashShoppingCartGoodsAfterDatas;

    NSMutableArray* ReservationShoppingCartGoodsDatas;
    NSMutableArray* ReservationShoppingCartGoodsBeforeDatas;
    NSMutableArray* ReservationShoppingCartGoodsAfterDatas;

    NSArray *shopArray;
    NSString *selectShop;
    UIView *selectShopBackView;
    
    NSString *gatherAct;
    
    id addressDatas;
    
    NSString *FlashNoteText;            //闪送备注
    NSString *FreshNoteText;            //预定备注
    
    id sendDatas;                       //传数据
    NSString *sendShopFreight;                 //传运费
    NSString *OrderType;                //闪送，预定
    NSString *Remark;                //闪送，预定
    
    NSMutableArray *leftTimeArray;             //左边时间
    NSMutableArray *rightTimeArray;             //右边时间
    NSMutableArray *rightTimeArray2;             //右边时间2
    
    NSString *sendTime;
    NSString *AccordingTime;
    
    NSMutableArray *rightArray1;
    NSMutableArray *rightArray2;
    
    NSString *BusinessHours;         //营业时间

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation shoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.01f)];
    self.tableView.tableHeaderView = view;

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    FlashNoteText = @"";
    FreshNoteText = @"";
    selectShop = @"0";
    if ((![USERDEFAULTS objectForKey:@"FlashShoppingCartGoods"] && ![USERDEFAULTS objectForKey:@"ReservationShoppingCartGoods"])||![USERDEFAULTS objectForKey:@"shopID"]) {
        _tableView.hidden = YES;
    }else{
        [self getDeliveryDatas];
    }
    [_tableView reloadData];
}
-(void)getDeliveryDatas{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] userAddressList:@"" lon:@"" success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            if ([USERDEFAULTS objectForKey:@"delectDetailedAddress"]) {
                addressDatas = [USERDEFAULTS objectForKey:@"delectDetailedAddress"];
            }else{
                addressDatas = [responseObject objectForKey:@"AppendData"][0];
            }
            [_tableView reloadData];
        }else {
            addressDatas = nil;
            [_tableView reloadData];
        }
        [self getStores:[USERDEFAULTS objectForKey:@"CurrentLatitude"] lon:[USERDEFAULTS objectForKey:@"CurrentLongitude"] Type:@"1"];
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark 根据坐标获取门店
-(void)getStores:(NSString *)lat lon:(NSString *)lon Type:(NSString *)Type{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] companyDetail:lat lon:lon Type:Type success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        NSArray * tempArray = [responseObject objectForKey:@"AppendData"];
        
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0 && tempArray.count >0) {
            [USERDEFAULTS setObject:[[responseObject objectForKey:@"AppendData"][0] objectForKey:@"Id"] forKey:@"shopID"];
            BusinessHours = [NSString stringWithFormat:@"%@:%@-%@:%@",[self fillA:[[responseObject objectForKey:@"AppendData"][0] objectForKey:@"ShopStartHour"]],[self fillA:[[responseObject objectForKey:@"AppendData"][0] objectForKey:@"ShopStartMinute"]],[self fillA:[[responseObject objectForKey:@"AppendData"][0] objectForKey:@"ShopEndHour"]],[self fillA:[[responseObject objectForKey:@"AppendData"][0] objectForKey:@"ShopEndMinute"]]];
            shopArray = [responseObject objectForKey:@"AppendData"];
            _tableView.hidden = NO;
            
        }else {
            _tableView.hidden = YES;
            [USERDEFAULTS setObject:nil forKey:@"shopID"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToBaseView" object:nil];
        }
        [self getCompareOrderList:@"1"];
        [self getCompareOrderList:@"2"];
        [self prestList];

        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark 检测商店是否包含购物车商品
-(void)getCompareOrderList:(NSString *)type{
    NSMutableArray *orderList = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    if ([type isEqualToString:@"1"]) {
        tempArray = [[USERDEFAULTS objectForKey:@"FlashShoppingCartGoods"] mutableCopy];
        for (int i = 0; i<tempArray.count; i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[tempArray[i] objectForKey:@"Fguid"] forKey:@"FguId"];
            [orderList addObject:dic];
        }
    }else{
        tempArray = [[USERDEFAULTS objectForKey:@"ReservationShoppingCartGoods"] mutableCopy];
        for (int i = 0; i<tempArray.count; i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[tempArray[i] objectForKey:@"Fguid"] forKey:@"FguId"];
            [orderList addObject:dic];
        }
    }
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] CompareOrderList:[USERDEFAULTS objectForKey:@"shopID"] OrderType:type OrderList:orderList success:^(id responseObject) {
        NSLog(@"%@",orderList);
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            if ([type isEqualToString:@"1"]) {
                NSArray *tempArray = [[responseObject objectForKey:@"AppendData"] objectForKey:@"ListOrder"];
                FlashShoppingCartGoodsDatas = [[NSMutableArray alloc]init];
                FlashShoppingCartGoodsBeforeDatas = [[NSMutableArray alloc]init];
                FlashShoppingCartGoodsAfterDatas = [[NSMutableArray alloc]init];
                
                for (int i = 0; i<tempArray.count; i++) {
                    if ([[tempArray[i] objectForKey:@"ProductLack"] intValue] == 1) {
                        [FlashShoppingCartGoodsBeforeDatas addObject:[USERDEFAULTS objectForKey:@"FlashShoppingCartGoods"][i]];
                    }else{
                        [FlashShoppingCartGoodsAfterDatas addObject:[USERDEFAULTS objectForKey:@"FlashShoppingCartGoods"][i]];
                    }
                }
                for (int i = 0; i<FlashShoppingCartGoodsBeforeDatas.count; i++) {
                    [FlashShoppingCartGoodsDatas addObject:FlashShoppingCartGoodsBeforeDatas[i]];
                }
                for (int i = 0; i<FlashShoppingCartGoodsAfterDatas.count; i++) {
                    [FlashShoppingCartGoodsDatas addObject:FlashShoppingCartGoodsAfterDatas[i]];
                }
            }else{
                NSArray *tempArray = [[responseObject objectForKey:@"AppendData"] objectForKey:@"ListOrder"];
                ReservationShoppingCartGoodsDatas = [[NSMutableArray alloc]init];
                ReservationShoppingCartGoodsBeforeDatas = [[NSMutableArray alloc]init];
                ReservationShoppingCartGoodsAfterDatas = [[NSMutableArray alloc]init];
                
                for (int i = 0; i<tempArray.count; i++) {
                    if ([[tempArray[i] objectForKey:@"ProductLack"] intValue] == 1) {
                        [ReservationShoppingCartGoodsBeforeDatas addObject:[USERDEFAULTS objectForKey:@"ReservationShoppingCartGoods"][i]];
                    }else{
                        [ReservationShoppingCartGoodsAfterDatas addObject:[USERDEFAULTS objectForKey:@"ReservationShoppingCartGoods"][i]];
                    }
                }
                for (int i = 0; i<ReservationShoppingCartGoodsBeforeDatas.count; i++) {
                    [ReservationShoppingCartGoodsDatas addObject:ReservationShoppingCartGoodsBeforeDatas[i]];
                }
                for (int i = 0; i<ReservationShoppingCartGoodsAfterDatas.count; i++) {
                    [ReservationShoppingCartGoodsDatas addObject:ReservationShoppingCartGoodsAfterDatas[i]];
                }
                
                
            }
            [_tableView reloadData];
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark 获取商店营业时间
-(void)prestList{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] prestList:[USERDEFAULTS objectForKey:@"shopID"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            leftTimeArray = [[NSMutableArray alloc]init];
            rightTimeArray = [[NSMutableArray alloc]init];
            NSArray * tempDatas = [responseObject objectForKey:@"AppendData"];
            for (int i = 0; i<tempDatas.count; i++) {
                [leftTimeArray addObject:[tempDatas[i] objectForKey:@"Key"]];
            }
            rightTimeArray = [[tempDatas[0] objectForKey:@"Value"] mutableCopy];
            rightTimeArray2 = [[tempDatas[1] objectForKey:@"Value"] mutableCopy];
            sendTime = [NSString stringWithFormat:@"%@%@",leftTimeArray[0],[rightTimeArray[0] objectForKey:@"Key"]];

            [_tableView reloadData];

        }else {
         
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (FlashShoppingCartGoodsDatas.count!=0 && ReservationShoppingCartGoodsDatas.count!=0){
        if (section == 1) {
            return FlashShoppingCartGoodsDatas.count;
        }else{
            return ReservationShoppingCartGoodsDatas.count;
        }
    }else if(FlashShoppingCartGoodsDatas.count!=0){
        return FlashShoppingCartGoodsDatas.count;
    }else if(ReservationShoppingCartGoodsDatas.count!=0){
        return ReservationShoppingCartGoodsDatas.count;
    }else{
        return 0;
    }

}
- (IBAction)toguangguang:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToBaseView" object:nil];
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        CGSize titleSize =[[NSString stringWithFormat:@"%@%@%@",[addressDatas objectForKey:@"CityName"],[addressDatas objectForKey:@"Address"],[addressDatas objectForKey:@"AddressDetail"]]  boundingRectWithSize:CGSizeMake(SCREENWIDTH-141, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return titleSize.height + 85;
    }else{
        return 35;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"shoppingCartAddressTableViewCell";
        shoppingCartAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"shoppingCartAddressTableViewCell" owner:self options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        if (addressDatas) {
            if ([addressDatas objectForKey:@"Name"]) {
                cell.name.text = [addressDatas objectForKey:@"Name"];
                cell.phoneNumber.text = [addressDatas objectForKey:@"Mobile"];
                cell.address.text = [NSString stringWithFormat:@"%@%@%@",[addressDatas objectForKey:@"CityName"],[addressDatas objectForKey:@"Address"],[addressDatas objectForKey:@"AddressDetail"]];
            }else{
                cell.name.text = [addressDatas objectForKey:@"CompanyName"];
                cell.phoneNumber.text = BusinessHours;
                cell.address.text = [addressDatas objectForKey:@"Address"];
                cell.hiddenLabel1.text = @"自";
                cell.hiddenLabel2.text = @"提";
                cell.hiddenLabel3.text = @"点";
                cell.hiddenLabel4.text = @"营业时间";
//                cell.hiddenLabel5.hidden = YES;
                cell.hiddenLabel6.text = @"提货地址";

            }
           
        }else{
            cell.name.hidden = YES;
            cell.phoneNumber.text = @"点击添加收货地址";
            cell.address.hidden = YES;
            cell.hiddenLabel1.hidden = YES;
            cell.hiddenLabel2.hidden = YES;
            cell.hiddenLabel3.hidden = YES;
            cell.hiddenLabel4.hidden = YES;
//            cell.hiddenLabel5.hidden = YES;
            cell.hiddenLabel6.hidden = YES;
        }
        [cell.addressManage addTarget:self action:@selector(addressManage:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else{
        static NSString *cellIdentifier = @"shoppingCartGoodsTableViewCell";
        shoppingCartGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"shoppingCartGoodsTableViewCell" owner:self options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(FlashShoppingCartGoodsDatas.count!=0 && indexPath.section == 1){
            cell.name.text = [FlashShoppingCartGoodsDatas[indexPath.row] objectForKey:@"Name"];
            cell.price.text = [NSString stringWithFormat:@"￥%.1f",[[FlashShoppingCartGoodsDatas[indexPath.row] objectForKey:@"Price"] floatValue]];
            cell.number.text = [NSString stringWithFormat:@"%@",[FlashShoppingCartGoodsDatas[indexPath.row] objectForKey:@"PurchaseQuantity"]];
            cell.plusButton.tag = indexPath.row;
            cell.minButton.tag = indexPath.row;

            if (indexPath.row < FlashShoppingCartGoodsBeforeDatas.count) {
                cell.backgroundColor = [UIColor whiteColor];
                cell.name.textColor = [UIColor blackColor];
                cell.price.textColor = [UIColor blackColor];
                cell.minButton.hidden = NO;
                cell.number.hidden = NO;
                [cell.plusButton setImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
                [cell.plusButton addTarget:self action:@selector(flashShoppingPlus:) forControlEvents:UIControlEventTouchUpInside];
                [cell.minButton addTarget:self action:@selector(flashShoppingMin:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                cell.backgroundColor = RGBCOLORA(239, 239, 239, 1);
                cell.name.textColor = RGBCOLORA(153, 153, 153, 1);
                cell.price.textColor = RGBCOLORA(153, 153, 153, 1);
                cell.minButton.hidden = YES;
                cell.number.hidden = YES;
                [cell.plusButton setImage:[UIImage imageNamed:@"del_icon"] forState:UIControlStateNormal];
                [cell.plusButton addTarget:self action:@selector(flashShoppingDel:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            cell.name.text = [ReservationShoppingCartGoodsDatas[indexPath.row] objectForKey:@"Name"];
            cell.price.text = [NSString stringWithFormat:@"￥%.1f",[[ReservationShoppingCartGoodsDatas[indexPath.row] objectForKey:@"Price"] floatValue]];
            cell.number.text = [ReservationShoppingCartGoodsDatas[indexPath.row] objectForKey:@"PurchaseQuantity"];
            cell.plusButton.tag = indexPath.row;
            cell.minButton.tag = indexPath.row;

            if (indexPath.row < ReservationShoppingCartGoodsBeforeDatas.count) {
                cell.backgroundColor = [UIColor whiteColor];
                cell.name.textColor = [UIColor blackColor];
                cell.price.textColor = [UIColor blackColor];
                cell.minButton.hidden = NO;
                cell.number.hidden = NO;
                [cell.plusButton setImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
                [cell.plusButton addTarget:self action:@selector(ReservationShoppingPlus:) forControlEvents:UIControlEventTouchUpInside];
                [cell.minButton addTarget:self action:@selector(ReservationShoppingMin:) forControlEvents:UIControlEventTouchUpInside];

            }else{
                cell.backgroundColor = RGBCOLORA(239, 239, 239, 1);
                cell.name.textColor = RGBCOLORA(153, 153, 153, 1);
                cell.price.textColor = RGBCOLORA(153, 153, 153, 1);
                cell.minButton.hidden = YES;
                cell.number.hidden = YES;
                [cell.plusButton setImage:[UIImage imageNamed:@"del_icon"] forState:UIControlStateNormal];
                [cell.plusButton addTarget:self action:@selector(ReservationShoppingDel:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSLog(@"address");
    }
}

#pragma mark 有几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (FlashShoppingCartGoodsDatas.count!=0 && ReservationShoppingCartGoodsDatas.count!=0) {
        _tableView.hidden = NO;
        return 3;
    }else if(FlashShoppingCartGoodsDatas.count!=0  || ReservationShoppingCartGoodsDatas.count!=0){
        _tableView.hidden = NO;
        return 2;
    }else{
        _tableView.hidden = YES;
        return 0;
    }
}
#pragma mark 头有多高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 137;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    headView = [[NSBundle mainBundle] loadNibNamed:@"shoppingCartHeadView" owner:self options:nil][0];
    [headView setFrame:CGRectMake(0, 0, SCREENWIDTH, 137)];
    if (section == 0) {
        return nil;
    }else if(FlashShoppingCartGoodsDatas.count!=0 && section == 1){
        if (selectShop) {
            headView.shopName.text = [shopArray[[selectShop intValue]] objectForKey:@"CompanyName"];
        }else{
            headView.shopName.text = [shopArray[0] objectForKey:@"CompanyName"];
        }
        if ([[USERDEFAULTS objectForKey:@"DeliveryType"] intValue] == 2) {
            headView.theRulesLbael.text = @"欢迎光临小超，我们等着你哦！";
            headView.timeButton.userInteractionEnabled = NO;
            headView.timeLabel1.text = @"请在小超营业时间内到店自提，谢谢！";
            headView.shopName.hidden = YES;
            headView.timeLabel2.hidden = YES;
        }else{
            if (rightArray1) {
                headView.timeLabel1.text = AccordingTime;
            }else{
                headView.timeLabel1.text = @"新鲜 马上送达";
            }
            headView.theRulesLbael.text = [NSString stringWithFormat:@"￥%@起送，配送费：￥%@",[shopArray[0] objectForKey:@"FromGetPrice"],[shopArray[0] objectForKey:@"DeliveryPrice"]];
        }
        headView.shopName.text = [shopArray[0] objectForKey:@"CompanyName"];
        headView.noteTextField.text = FlashNoteText;
        headView.togetherButton.tag = 1;
        [headView.togetherButton addTarget:self action:@selector(togetherButton:) forControlEvents:UIControlEventTouchUpInside];
//        [headView.flashButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView.noteTextField addTarget:self action:@selector(flashNoteText:) forControlEvents:UIControlEventEditingChanged];
        [headView.timeButton addTarget:self action:@selector(timeButton:) forControlEvents:UIControlEventTouchUpInside];
        return headView;
    }else{
        
        if ([[USERDEFAULTS objectForKey:@"DeliveryType"] intValue] == 2) {
            headView.timeButton.userInteractionEnabled = NO;
            headView.timeLabel1.text = @"我们会在第一时间通知你，到店取货时间，谢谢！";
        }else{
            headView.timeLabel1.text = @"明天10：00-18：00";
        }
        headView.theRulesLbael.text = [NSString stringWithFormat:@"￥%@起送，配送费：￥%@",[shopArray[0] objectForKey:@"FreshDeliveryPrice"],[shopArray[0] objectForKey:@"FreshFromGetPrice"]];
        [headView.flashImage setImage:[UIImage imageNamed:@"shop_cart_xxyd"]];
        [headView.flashButton setTitle:@"新鲜预定" forState:UIControlStateNormal];
        headView.arrowImage.hidden = YES;
        headView.shopName.hidden = YES;
        [headView.roundView setBackgroundColor:RGBCOLORA(131, 199, 252, 1)];
        headView.timeLabel2.hidden = YES;
        headView.noteTextField.text = FreshNoteText;
        headView.togetherButton.tag = 2;
        [headView.togetherButton addTarget:self action:@selector(togetherButton:) forControlEvents:UIControlEventTouchUpInside];
        [headView.noteTextField addTarget:self action:@selector(FreshNoteText:) forControlEvents:UIControlEventEditingChanged];

        return headView;
    }
}
#pragma mark 闪送小超选时间
-(void)timeButton:(UIButton *)sender{
    NSLog(@"选时间");
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithObjects:@"今天",@"明天",@"后天",nil];
    rightArray1 = [[NSMutableArray alloc]init];
    rightArray2 = [[NSMutableArray alloc]init];
    for (int i = 0; i<rightTimeArray.count; i++) {
        if (i == 0) {
            [rightArray1 addObject:@"新鲜 马上送达"];
        }else{
            [rightArray1 addObject:[NSString stringWithFormat:@"%@-%@",[rightTimeArray[i] objectForKey:@"Key"],[rightTimeArray[i] objectForKey:@"Value"]]];
        }
    }
    for (int i = 0; i<rightTimeArray2.count; i++) {
        [rightArray2 addObject:[NSString stringWithFormat:@"%@-%@",[rightTimeArray2[i] objectForKey:@"Key"],[rightTimeArray2[i] objectForKey:@"Value"]]];
    }
    NSLog(@"%@%@",rightArray1,rightArray2);
    
    NewDatePicker *alv = [[NewDatePicker alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHTIGHT)];
    alv.delegate = self;
    alv.leftArray= tempArray;
    alv.right1Array= rightArray1;
    alv.right2Array = rightArray2;
    alv.NewrightArray = alv.right1Array;
    alv.dayString = @"0";
    alv.hourString = @"0";
    [self.navigationController.view addSubview:alv];

}
-(void)sendtime:(NSString *)year hour:(NSString *)hour{
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithObjects:@"今天",@"明天",@"后天",nil];

    if ([year intValue] == 0 && [hour intValue]==0) {
        AccordingTime = @"新鲜 马上送达";
    }else{
        if ([year intValue] == 0) {
            AccordingTime = [NSString stringWithFormat:@"%@%@",tempArray[[year intValue]],rightArray1[[hour intValue]]];
        }else{
            AccordingTime = [NSString stringWithFormat:@"%@%@",tempArray[[year intValue]],rightArray2[[hour intValue]]];
        }
    }
    if ([year intValue] == 0) {
        NSLog(@"%@%@",leftTimeArray[[year intValue]],[rightTimeArray[[hour intValue]] objectForKey:@"Key"]);
        sendTime = [NSString stringWithFormat:@"%@%@",leftTimeArray[[year intValue]],[rightTimeArray[[hour intValue]] objectForKey:@"Key"]];
    }else{
        NSLog(@"%@%@",leftTimeArray[[year intValue]],[rightTimeArray2[[hour intValue]] objectForKey:@"Key"]);
        sendTime = [NSString stringWithFormat:@"%@%@",leftTimeArray[[year intValue]],[rightTimeArray2[[hour intValue]] objectForKey:@"Key"]];
    }
    
//    [headView.timeButton setTitle:sendTime forState:UIControlStateNormal];
    [_tableView reloadData];
}
#pragma mark  闪送小超按钮
-(void)flashButtonClick:(UIButton *)sender{
    selectShopBackView = [[UIView alloc]init];
    UIButton *selectShopButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *selectShopButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *selectShopButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectShopButton1 setFrame:CGRectMake(0, 0, 200, 48)];
    [selectShopButton2 setFrame:CGRectMake(0, 48, 200, 48)];
    [selectShopButton3 setFrame:CGRectMake(0, 96, 200, 48)];
    [selectShopButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectShopButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectShopButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if (shopArray.count == 1) {
        [selectShopButton1 setTitle:[shopArray[0] objectForKey:@"CompanyName"] forState:UIControlStateNormal];
        [selectShopBackView setFrame:CGRectMake(SCREENWIDTH/2-100, SCREENHTIGHT/2-24, 200, 48)];
        [selectShopBackView addSubview:selectShopButton1];
    }else if (shopArray.count == 2){
        [selectShopButton1 setTitle:[shopArray[0] objectForKey:@"CompanyName"] forState:UIControlStateNormal];
        [selectShopButton2 setTitle:[shopArray[1] objectForKey:@"CompanyName"] forState:UIControlStateNormal];
        [selectShopBackView setFrame:CGRectMake(SCREENWIDTH/2-100, SCREENHTIGHT/2-48, 200, 96)];
        [selectShopBackView addSubview:selectShopButton1];
        [selectShopBackView addSubview:selectShopButton2];
    }else if (shopArray.count >= 3){
        [selectShopButton1 setTitle:[shopArray[0] objectForKey:@"CompanyName"] forState:UIControlStateNormal];
        [selectShopButton2 setTitle:[shopArray[1] objectForKey:@"CompanyName"] forState:UIControlStateNormal];
        [selectShopButton3 setTitle:[shopArray[2] objectForKey:@"CompanyName"] forState:UIControlStateNormal];
        [selectShopBackView setFrame:CGRectMake(SCREENWIDTH/2-100, SCREENHTIGHT/2-72, 200, 144)];
        [selectShopBackView addSubview:selectShopButton1];
        [selectShopBackView addSubview:selectShopButton2];
        [selectShopBackView addSubview:selectShopButton3];
    }
    selectShopButton1.tag = 0;
    selectShopButton2.tag = 1;
    selectShopButton3.tag = 2;

    [selectShopButton1 addTarget:self action:@selector(selectShopButton:) forControlEvents:UIControlEventTouchUpInside];
    [selectShopButton2 addTarget:self action:@selector(selectShopButton:) forControlEvents:UIControlEventTouchUpInside];
    [selectShopButton3 addTarget:self action:@selector(selectShopButton:) forControlEvents:UIControlEventTouchUpInside];
    selectShopBackView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:selectShopBackView];
}
-(void)selectShopButton:(UIButton *)sender{
    selectShop = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [USERDEFAULTS setObject:[shopArray[sender.tag] objectForKey:@"Id"] forKey:@"shopID"];
    [self getCompareOrderList:@"1"];
    [self getCompareOrderList:@"2"];
    [selectShopBackView removeFromSuperview];
}
#pragma mark  凑单专区
-(void)togetherButton:(UIButton *)sender{
    gatherAct = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self performSegueWithIdentifier:@"shoppingCartToGatherTogetherASingle" sender:self];
}
#pragma mark 底部有多高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }else{
        return 61;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    footView = [[NSBundle mainBundle] loadNibNamed:@"shoppingCartFootView" owner:self options:nil][0];
    [footView setFrame:CGRectMake(0, 0, SCREENWIDTH, 61)];
    footView.toPayButton.tag = section;
    if (section == 0) {
        return nil;
    }else if(FlashShoppingCartGoodsDatas.count!=0 && section == 1){
        float tempPrice = 0;
        for (int i = 0; i<FlashShoppingCartGoodsBeforeDatas.count; i++) {
            tempPrice += [[FlashShoppingCartGoodsBeforeDatas[i] objectForKey:@"Price"] floatValue]*[[FlashShoppingCartGoodsBeforeDatas[i] objectForKey:@"PurchaseQuantity"] floatValue];
        }
        footView.priceLabel.text = [NSString stringWithFormat:@"共￥%.1f",tempPrice];
        NSLog(@"%@",shopArray);
        if ([[shopArray[0] objectForKey:@"FromGetPrice"] floatValue] > tempPrice) {
            [footView.toPayButton setTitle:[NSString stringWithFormat:@"满￥%d元起送",[[shopArray[0] objectForKey:@"FromGetPrice"] intValue]] forState:UIControlStateNormal];
            [footView.toPayButton setBackgroundColor:[UIColor lightGrayColor]];
            footView.toPayButton.userInteractionEnabled = NO;
        }else{
            [footView.toPayButton setTitle:@"选好了" forState:UIControlStateNormal];
            [footView.toPayButton setBackgroundColor:RGBCOLORA(255, 214, 0, 1)];
            footView.toPayButton.userInteractionEnabled = YES;
        }
        footView.toPayButton.tag = 10001;
        [footView.toPayButton addTarget:self action:@selector(toPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return footView;
    }else{
        float tempPrice = 0;
        for (int i = 0; i<ReservationShoppingCartGoodsBeforeDatas.count; i++) {
            tempPrice += [[ReservationShoppingCartGoodsBeforeDatas[i] objectForKey:@"Price"] floatValue]*[[ReservationShoppingCartGoodsBeforeDatas[i] objectForKey:@"PurchaseQuantity"] floatValue];
        }
        footView.priceLabel.text = [NSString stringWithFormat:@"共￥%.1f",tempPrice];
        
        footView.toPayButton.tag = 10002;
        [footView.toPayButton addTarget:self action:@selector(toPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return footView;
    }
    
}
#pragma mark 闪送小超
-(void)flashShoppingPlus:(UIButton *)sender{
    NSMutableDictionary *tempDic = [FlashShoppingCartGoodsDatas[sender.tag] mutableCopy];
    [tempDic setObject:[NSString stringWithFormat:@"%d",[[tempDic objectForKey:@"PurchaseQuantity"] intValue]+1] forKey:@"PurchaseQuantity"];
    FlashShoppingCartGoodsDatas[sender.tag] = tempDic;
    
    NSMutableDictionary *tempDic2 = [FlashShoppingCartGoodsBeforeDatas[sender.tag] mutableCopy];
    [tempDic2 setObject:[NSString stringWithFormat:@"%d",[[tempDic2 objectForKey:@"PurchaseQuantity"] intValue]+1] forKey:@"PurchaseQuantity"];
    FlashShoppingCartGoodsBeforeDatas[sender.tag] = tempDic2;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsAdd" object:FlashShoppingCartGoodsDatas[sender.tag]];

    [_tableView reloadData];
}
-(void)flashShoppingMin:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsMin" object:FlashShoppingCartGoodsDatas[sender.tag]];

    NSMutableDictionary *tempDic = [FlashShoppingCartGoodsDatas[sender.tag] mutableCopy];
    NSMutableDictionary *tempDic2 = [FlashShoppingCartGoodsBeforeDatas[sender.tag] mutableCopy];
    
    if ([[FlashShoppingCartGoodsDatas[sender.tag] objectForKey:@"PurchaseQuantity"] intValue] == 1) {
        [FlashShoppingCartGoodsDatas removeObjectAtIndex:sender.tag];
        [FlashShoppingCartGoodsBeforeDatas removeObjectAtIndex:sender.tag];
    }else{
        [tempDic setObject:[NSString stringWithFormat:@"%d",[[tempDic objectForKey:@"PurchaseQuantity"] intValue]-1] forKey:@"PurchaseQuantity"];
        [tempDic2 setObject:[NSString stringWithFormat:@"%d",[[tempDic2 objectForKey:@"PurchaseQuantity"] intValue]-1] forKey:@"PurchaseQuantity"];
        FlashShoppingCartGoodsDatas[sender.tag] = tempDic;
        FlashShoppingCartGoodsBeforeDatas[sender.tag] = tempDic2;
    }
    
    [_tableView reloadData];
}
-(void)flashShoppingDel:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FlashShoppingCartGoodsDelete" object:FlashShoppingCartGoodsDatas[sender.tag]];
    [FlashShoppingCartGoodsDatas removeObjectAtIndex:sender.tag];
    [FlashShoppingCartGoodsAfterDatas removeObjectAtIndex:sender.tag-FlashShoppingCartGoodsBeforeDatas.count];

    [_tableView reloadData];
}
#pragma mark 新鲜预定
-(void)ReservationShoppingPlus:(UIButton *)sender{
    NSMutableDictionary *tempDic = [ReservationShoppingCartGoodsDatas[sender.tag] mutableCopy];
    [tempDic setObject:[NSString stringWithFormat:@"%d",[[tempDic objectForKey:@"PurchaseQuantity"] intValue]+1] forKey:@"PurchaseQuantity"];
    ReservationShoppingCartGoodsDatas[sender.tag] = tempDic;
    
    NSMutableDictionary *tempDic2 = [ReservationShoppingCartGoodsBeforeDatas[sender.tag] mutableCopy];
    [tempDic2 setObject:[NSString stringWithFormat:@"%d",[[tempDic2 objectForKey:@"PurchaseQuantity"] intValue]+1] forKey:@"PurchaseQuantity"];
    ReservationShoppingCartGoodsBeforeDatas[sender.tag] = tempDic2;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReservationShoppingCartGoodsAdd" object:ReservationShoppingCartGoodsDatas[sender.tag]];
    
    [_tableView reloadData];
}
-(void)ReservationShoppingMin:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReservationShoppingCartGoodsMin" object:ReservationShoppingCartGoodsDatas[sender.tag]];
    
    NSMutableDictionary *tempDic = [ReservationShoppingCartGoodsDatas[sender.tag] mutableCopy];
    NSMutableDictionary *tempDic2 = [ReservationShoppingCartGoodsBeforeDatas[sender.tag] mutableCopy];
    
    if ([[ReservationShoppingCartGoodsDatas[sender.tag] objectForKey:@"PurchaseQuantity"] intValue] == 1) {
        [ReservationShoppingCartGoodsDatas removeObjectAtIndex:sender.tag];
        [ReservationShoppingCartGoodsBeforeDatas removeObjectAtIndex:sender.tag];
    }else{
        [tempDic setObject:[NSString stringWithFormat:@"%d",[[tempDic objectForKey:@"PurchaseQuantity"] intValue]-1] forKey:@"PurchaseQuantity"];
        [tempDic2 setObject:[NSString stringWithFormat:@"%d",[[tempDic2 objectForKey:@"PurchaseQuantity"] intValue]-1] forKey:@"PurchaseQuantity"];
        ReservationShoppingCartGoodsDatas[sender.tag] = tempDic;
        ReservationShoppingCartGoodsBeforeDatas[sender.tag] = tempDic2;
    }
    
    [_tableView reloadData];
}
-(void)ReservationShoppingDel:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReservationShoppingCartGoodsDelete" object:ReservationShoppingCartGoodsDatas[sender.tag]];
    [ReservationShoppingCartGoodsDatas removeObjectAtIndex:sender.tag];
    [ReservationShoppingCartGoodsAfterDatas removeObjectAtIndex:sender.tag-ReservationShoppingCartGoodsBeforeDatas.count];
    
    [_tableView reloadData];
}

#pragma mark 去支付
-(void)toPayButtonClick:(UIButton *)sender{
    if (sender.tag == 10001) {
        if (FlashShoppingCartGoodsBeforeDatas.count <= 0) {
            [SVProgressHUD showInfoWithStatus:@"您还没有选择商品哟!"];
        }else{
            sendDatas = FlashShoppingCartGoodsBeforeDatas;
            sendShopFreight = [NSString stringWithFormat:@"%@",[shopArray[0] objectForKey:@"DeliveryPrice"]];
            OrderType = @"1";
            Remark = FlashNoteText;
            [self performSegueWithIdentifier:@"shoppingCartViewToSubmitOrders" sender:self];
        }
    }else{
        if (ReservationShoppingCartGoodsBeforeDatas.count <= 0) {
            [SVProgressHUD showInfoWithStatus:@"您还没有选择商品哟!"];
        }else{
            sendDatas = ReservationShoppingCartGoodsBeforeDatas;
            sendShopFreight = [NSString stringWithFormat:@"%@",[shopArray[0] objectForKey:@"FreshDeliveryPrice"]];
            OrderType = @"2";
            Remark = FreshNoteText;
            [self performSegueWithIdentifier:@"shoppingCartViewToSubmitOrders" sender:self];
        }
    }
}
#pragma mark 跳转地址
-(void)addressManage:(UIButton *)sender{
    [self performSegueWithIdentifier:@"shoppingCartToAddressManage" sender:self];
}
-(void)flashNoteText:(UITextField *)sender{
    FlashNoteText = sender.text;
}
-(void)FreshNoteText:(UITextField *)sender{
    FreshNoteText = sender.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"shoppingCartToGatherTogetherASingle"]) {
        GatherTogetherASingleViewController *GatherTogetherASingleVC = segue.destinationViewController;
        [GatherTogetherASingleVC setIsAct:gatherAct];
    }
    if ([segue.identifier isEqualToString:@"shoppingCartViewToSubmitOrders"]) {
        submitOrdersViewController *submitOrdersVC = segue.destinationViewController;
        [submitOrdersVC setGetDatas:sendDatas];
        [submitOrdersVC setGetFreight:sendShopFreight];
        [submitOrdersVC setOrderType:OrderType];
        [submitOrdersVC setRemark:Remark];
        [submitOrdersVC setTime:sendTime];
    }
}
#pragma mark 时间补位
-(NSString *)fillA:(NSString *)sender{
    sender = [NSString stringWithFormat:@"%@",sender];
    NSString *tempStr;
    if (sender.length == 1) {
        tempStr = [NSString stringWithFormat:@"%@0",sender];
    }else{
        tempStr = sender;
    }
    return tempStr;
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
