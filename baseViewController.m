//
//  baseViewController.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//

#import "baseViewController.h"
#import "tabBarViewController.h"
#import "guideView.h"
#import "shufflingTableViewCell.h"
#import "classificationTableViewCell.h"
#import "headlinesTableViewCell.h"
#import "recommendFourTableViewCell.h"
#import "goodsProjectTableViewCell.h"
#import "CrossSellingTableViewCell.h"

//#import <AlipaySDK/AlipaySDK.h>


@interface baseViewController ()<SDCycleScrollViewDelegate,UIGestureRecognizerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,positioningDelegate>
{
    guideView *guiView;
    UIView *backView; //引导页背景
    BOOL isbool;
    
    BMKLocationService *_locService;
    BMKGeoCodeSearch * _searcher;
    
    NSArray *scrollDatas;           //轮播图数据
    NSArray *sevenDatas;            //顶部7条数据
    NSArray *indexDatas;            //活动列表数据
    NSArray *proHeatDatas;            //叉叉热卖数据

}
@property (weak, nonatomic) IBOutlet UILabel *deliveryTo;   //配送至
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *titleAddress;
@property (weak, nonatomic) IBOutlet UIButton *changeAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleAddressWidth;         //地址宽度

/** layers */
@property(nonatomic,strong)NSMutableArray<CALayer *> *animationLayers;

@end
// 合作商家5按钮    [[NSNotificationCenter defaultCenter] postNotificationName:@"initFiveButton" object:nil];
// 非合作商家4按钮   [[NSNotificationCenter defaultCenter] postNotificationName:@"initFourButton" object:nil];
@implementation baseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _changeAddress.layer.borderColor = RGBCOLORA(115, 113, 114, 1).CGColor;
    _changeAddress.layer.borderWidth = 1;
    _changeAddress.layer.cornerRadius = 4;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"initFiveButton" object:nil];
    _tableView.hidden = YES;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    _deliveryTo.layer.borderColor = [UIColor blackColor].CGColor;
    _deliveryTo.layer.borderWidth = 0.5;
    // Do any additional setup after loading the view.
    [self getCurrentAddress];

//    NSString *orderString = @"partner=2088221732730795&seller_id=513029998@qq.com&out_trade_no=201606171455082316&subject=测试订单&body=测试订单&total_fee=0.1&notify_url=manage.feichacha.com/Pay/NotifyUrl&service=mobile.securitypay.pay&payment_type=1&_input_charset=utf-8&it_b_pay=30m&show_url=m.alipay.com&sign_type=RSA&sign=Kl00J0dclsehpwpe1qGqeMJTtuLdeF8yAwq8Jw7ue5nlknvCGvSLvvMekRVMm7d/KyfKM6cASLTbzu/OPjyCgYG5p6phRlPFQR6GZ9SlLUk5Gut1JzMDvlNnqgvhrfplFnuKgOA5+FowXxdGF4jieL40dq/8FLD2oYhjfTHBU4Y=";
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"feichacha" callback:^(NSDictionary *resultDic) {
//        NSLog(@"reslut = %@",resultDic);
//    }];

}
-(void)viewWillAppear:(BOOL)animated{
    if (![_titleAddress.titleLabel.text isEqualToString:[USERDEFAULTS objectForKey:@"CurrentAddress"]] && ![_titleAddress.titleLabel.text isEqualToString:@"选择收货地址"]) {
        [self getStores:[USERDEFAULTS objectForKey:@"CurrentLatitude"] lon:[USERDEFAULTS objectForKey:@"CurrentLongitude"]];
        [_titleAddress setTitle:[USERDEFAULTS objectForKey:@"CurrentAddress"] forState:UIControlStateNormal];
        [self initAddressTitleWidth:[USERDEFAULTS objectForKey:@"CurrentAddress"]];
    }

}
//获取当前地址
-(void)getCurrentAddress{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation) {
//        发起反向地理编码检索
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
        BMKReverseGeoCodeOption alloc]init];
        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
        if(flag)
        {
//          NSLog(@"反geo检索发送成功");
            NSString *latString = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
            NSString *lonString = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
            [USERDEFAULTS setObject:lonString forKey:@"CurrentLongitude"];
            [USERDEFAULTS setObject:latString forKey:@"CurrentLatitude"];
            [self getStores:latString lon:lonString];
            _locService.delegate = nil;
        }
        else
        {
          NSLog(@"反geo检索发送失败");    
        }
        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    }
}
#pragma mark 根据坐标获取门店
-(void)getStores:(NSString *)lat lon:(NSString *)lon{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[NetworkUtils shareNetworkUtils] companyDetail:lat lon:lon Type:@"0" success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
                [self initGuideView];
            }
            
            [USERDEFAULTS setObject:[[responseObject objectForKey:@"AppendData"] objectForKey:@"Id"] forKey:@"shopID"];
            _tableView.hidden = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initFiveButton" object:nil];

            [self getScrollDatas];
        }else {
            _tableView.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initFourButton" object:nil];
            [USERDEFAULTS setObject:nil forKey:@"shopID"];
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark 获取轮播图数据
-(void)getScrollDatas{
    [[NetworkUtils shareNetworkUtils] scrollList:[USERDEFAULTS objectForKey:@"shopID"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            scrollDatas = [responseObject objectForKey:@"AppendData"];
            [_tableView reloadData];
            [self getSevenDatas];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
//        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
//        [SVProgressHUD dismiss];
    }];
}
#pragma mark 获取首页置顶7条数据
-(void)getSevenDatas{
    [[NetworkUtils shareNetworkUtils] sevenList:[USERDEFAULTS objectForKey:@"shopID"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            sevenDatas = [responseObject objectForKey:@"AppendData"];
            [_tableView reloadData];
            [self indexListDatas];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        //        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        //        [SVProgressHUD dismiss];
    }];
}
#pragma mark 获取首页活动列表
-(void)indexListDatas{
    [[NetworkUtils shareNetworkUtils]indexList:[USERDEFAULTS objectForKey:@"shopID"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            indexDatas = [responseObject objectForKey:@"AppendData"];
            [_tableView reloadData];
            [self proHeatDatas];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
        //        [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        //        [SVProgressHUD dismiss];
    }];
}
#pragma mark 首页获取叉叉热卖商品
-(void)proHeatDatas{
    [[NetworkUtils shareNetworkUtils]proHeat:[USERDEFAULTS objectForKey:@"shopID"] success:^(id responseObject) {
        NSLog(@"数据:%@",responseObject);
        if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
            proHeatDatas = [responseObject objectForKey:@"AppendData"];
            [_tableView reloadData];
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
        }
//                [SVProgressHUD dismiss];
    } failure:^(NSString *error) {
        //        [SVProgressHUD dismiss];
    }];
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      NSMutableArray * tempArray = [[NSMutableArray alloc]init];
      for(BMKPoiInfo *poiInfo in result.poiList)
      {
          [tempArray addObject:poiInfo.name];
      }
      [_titleAddress setTitle:tempArray[0] forState:UIControlStateNormal];
      [USERDEFAULTS setObject:tempArray[0] forKey:@"CurrentAddress"];
      [self initAddressTitleWidth:tempArray[0]];
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}
//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    _searcher.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"initFiveButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"initFourButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpToFlashSmallSupper" object:nil];
}

#pragma mark CELL的row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}
#pragma mark CELL的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 125;
    }else if(indexPath.row == 1){
        return 70;
    }else if(indexPath.row == 2){
        return SCREENWIDTH/3*1.26+24;
    }else if (indexPath.row == 3){
        return SCREENWIDTH*0.37;
    }else if (indexPath.row >= 4 &&indexPath.row <= 12){
        return SCREENWIDTH*0.255+235;
    }else{
        return 580;
    }
}
#pragma mark CELL的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"shufflingTableViewCell";
        shufflingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"shufflingTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.shufflingView.delegate = self;
        NSMutableArray *imageUrl = [[NSMutableArray alloc]init];
        for (int i = 0; i<scrollDatas.count; i++) {
            [imageUrl addObject:[NSString stringWithFormat:@"%@%@",IMGURL,[scrollDatas[i] objectForKey:@"ImageUrl"]]];
        }
        cell.shufflingView.imageURLStringsGroup = imageUrl;
        cell.shufflingView.placeholderImage = [UIImage imageNamed:@"banner"];
        cell.shufflingView.autoScrollTimeInterval = 3.0;
        
        
        return cell;
    }else if(indexPath.row == 1){
        static NSString *cellIdentifier = @"classificationTableViewCell";
        classificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"classificationTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.classButton1 addTarget:self action:@selector(headClassButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.classButton2 addTarget:self action:@selector(headClassButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.classButton3 addTarget:self action:@selector(headClassButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.classButton4 addTarget:self action:@selector(headClassButton:) forControlEvents:UIControlEventTouchUpInside];

        
        return cell;
    }else if(indexPath.row == 2){
        static NSString *cellIdentifier = @"headlinesTableViewCell";
        headlinesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"headlinesTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[sevenDatas[0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[sevenDatas[1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.goodsImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[sevenDatas[2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.salesPromotionClick addTarget:self action:@selector(salesPromotionClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.classClick1 addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.classClick2 addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.classClick3 addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if(indexPath.row == 3){
        static NSString *cellIdentifier = @"recommendFourTableViewCell";
        recommendFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"recommendFourTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[sevenDatas[3] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"index-4-1"]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[sevenDatas[4] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"index-4-1"]];
        [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[sevenDatas[5] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"index-4-1"]];
        [cell.image4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[sevenDatas[6] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"index-4-1"]];
        [cell.button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button4 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if(indexPath.row >= 4 &&indexPath.row <= 12){
        static NSString *cellIdentifier = @"goodsProjectTableViewCell";
        goodsProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"goodsProjectTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[indexDatas[indexPath.row-4] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"index-8-1"]];
        cell.titleName.text = [indexDatas[indexPath.row-4] objectForKey:@"Name"];
        
        if ([[indexDatas[indexPath.row-4] objectForKey:@"ActType"] intValue] == 1) {
            [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            [cell.goodsImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName1.text = [[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:0] objectForKey:@"Name"];
            cell.goodsName2.text = [[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:1] objectForKey:@"Name"];
            cell.goodsName3.text = [[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:2] objectForKey:@"Name"];
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:0] objectForKey:@"IsDirect"] boolValue]) {
                cell.goodsDescribe1_1.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
                cell.goodsDescribe1_1.layer.borderWidth = 1;
                cell.goodsDescribe1_1.layer.cornerRadius = 8;
                cell.goodsDescribe1_1.text = @"进";
                cell.goodsDescribe1_1.textColor = RGBCOLORA(114, 172, 74, 1);
                cell.goodsDescribe1_2.hidden = YES;
            }
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:1] objectForKey:@"IsDirect"] boolValue]) {
                cell.goodsDescribe2_1.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
                cell.goodsDescribe2_1.layer.borderWidth = 1;
                cell.goodsDescribe2_1.layer.cornerRadius = 8;
                cell.goodsDescribe2_1.text = @"进";
                cell.goodsDescribe2_1.textColor = RGBCOLORA(114, 172, 74, 1);
                cell.goodsDescribe2_2.hidden = YES;
            }
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:2] objectForKey:@"IsDirect"] boolValue]) {
                cell.goodsDescribe3_1.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
                cell.goodsDescribe3_1.layer.borderWidth = 1;
                cell.goodsDescribe3_1.layer.cornerRadius = 8;
                cell.goodsDescribe3_1.text = @"进";
                cell.goodsDescribe3_1.textColor = RGBCOLORA(114, 172, 74, 1);
                cell.goodsDescribe3_2.hidden = YES;
            }
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:0] objectForKey:@"IsImport"] boolValue]) {
                cell.goodsDescribe1_1.hidden = YES;
            }
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:1] objectForKey:@"IsImport"] boolValue]) {
                cell.goodsDescribe2_1.hidden = YES;
            }
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:2] objectForKey:@"IsImport"] boolValue]) {
                cell.goodsDescribe3_1.hidden = YES;
            }
            
            cell.goodsMessage1.text = [[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:0] objectForKey:@"Size"];
            cell.goodsMessage2.text = [[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:1] objectForKey:@"Size"];
            cell.goodsMessage3.text = [[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:2] objectForKey:@"Size"];
            
            cell.goodsPrice1.text = [NSString stringWithFormat:@"￥%@",[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:0] objectForKey:@"Price"]];
            cell.goodsPrice2.text = [NSString stringWithFormat:@"￥%@",[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:1] objectForKey:@"Price"]];
            cell.goodsPrice3.text = [NSString stringWithFormat:@"￥%@",[[[indexDatas[indexPath.row-4] objectForKey:@"CompanyProduct"] objectAtIndex:2] objectForKey:@"Price"]];

        }else{
            [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            [cell.goodsImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
            cell.goodsName1.text = [[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:0] objectForKey:@"Name"];
            cell.goodsName2.text = [[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:1] objectForKey:@"Name"];
            cell.goodsName3.text = [[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:2] objectForKey:@"Name"];
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:0] objectForKey:@"IsDirect"] boolValue]) {
                cell.goodsDescribe1_1.hidden = YES;
            }
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:1] objectForKey:@"IsDirect"] boolValue]) {
                cell.goodsDescribe2_1.hidden = YES;
            }
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:2] objectForKey:@"IsDirect"] boolValue]) {
                cell.goodsDescribe3_1.hidden = YES;
            }
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:0] objectForKey:@"IsImport"] boolValue]) {
                cell.goodsDescribe1_2.hidden = YES;
            }
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:1] objectForKey:@"IsImport"] boolValue]) {
                cell.goodsDescribe2_2.hidden = YES;
            }
            if (![[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:2] objectForKey:@"IsImport"] boolValue]) {
                cell.goodsDescribe3_2.hidden = YES;
            }
            
            cell.goodsMessage1.text = [[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:0] objectForKey:@"Size"];
            cell.goodsMessage2.text = [[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:1] objectForKey:@"Size"];
            cell.goodsMessage3.text = [[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:2] objectForKey:@"Size"];
            
            cell.goodsPrice1.text = [NSString stringWithFormat:@"￥%@",[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:0] objectForKey:@"Price"]];
            cell.goodsPrice2.text = [NSString stringWithFormat:@"￥%@",[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:1] objectForKey:@"Price"]];
            cell.goodsPrice3.text = [NSString stringWithFormat:@"￥%@",[[[indexDatas[indexPath.row-4] objectForKey:@"FreshCompany"] objectAtIndex:2] objectForKey:@"Price"]];
        }
        cell.goodsDescribe1_3.hidden = YES;
        cell.goodsDescribe2_3.hidden = YES;
        cell.goodsDescribe3_3.hidden = YES;
        cell.goodsOldPrice1.hidden = YES;
        cell.goodsOldPrice2.hidden = YES;
        cell.goodsOldPrice3.hidden = YES;

//        /**
//         老价格加下划线
//         **/
//        NSString *oldPrice = @"¥ 99.9";
//        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
//        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
//        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, oldPrice.length)];
//        [cell.goodsOldPrice1 setAttributedText:attri];
//        [cell.goodsOldPrice2 setAttributedText:attri];
//        [cell.goodsOldPrice3 setAttributedText:attri];

        [cell.classButton addTarget:self action:@selector(classButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsButton1 addTarget:self action:@selector(goodsButton1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsButton2 addTarget:self action:@selector(goodsButton2:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsButton3 addTarget:self action:@selector(goodsButton3:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addShoppingCartButton1 addTarget:self action:@selector(addShoppingCartButton1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addShoppingCartButton2 addTarget:self action:@selector(addShoppingCartButton2:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addShoppingCartButton3 addTarget:self action:@selector(addShoppingCartButton3:) forControlEvents:UIControlEventTouchUpInside];
        [cell.moreButton addTarget:self action:@selector(moreButton:) forControlEvents:UIControlEventTouchUpInside];

        cell.classButton.tag = indexPath.row-4;
        cell.goodsButton1.tag = indexPath.row-4;
        cell.goodsButton2.tag = indexPath.row-4;
        cell.goodsButton3.tag = indexPath.row-4;
        cell.addShoppingCartButton1.tag = indexPath.row-4;
        cell.addShoppingCartButton2.tag = indexPath.row-4;
        cell.addShoppingCartButton3.tag = indexPath.row-4;
        cell.moreButton.tag = indexPath.row-4;

        return cell;

    }else{
        static NSString *cellIdentifier = @"CrossSellingTableViewCell";
        CrossSellingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CrossSellingTableViewCell" owner:self options:nil][0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[proHeatDatas[0] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[proHeatDatas[1] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.goodsImage3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[proHeatDatas[2] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        [cell.goodsImage4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMGURL,[proHeatDatas[3] objectForKey:@"ImageUrl"]]] placeholderImage:[UIImage imageNamed:@"loading_default"]];
        
        cell.goodsName1.text = [proHeatDatas[0] objectForKey:@"Name"];
        cell.goodsName2.text = [proHeatDatas[1] objectForKey:@"Name"];
        cell.goodsName3.text = [proHeatDatas[2] objectForKey:@"Name"];
        cell.goodsName4.text = [proHeatDatas[3] objectForKey:@"Name"];
        
        if (![[proHeatDatas[0] objectForKey:@"IsDirect"] boolValue]) {
            cell.goodsDescribe1_1.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
            cell.goodsDescribe1_1.layer.borderWidth = 1;
            cell.goodsDescribe1_1.layer.cornerRadius = 8;
            cell.goodsDescribe1_1.text = @"进";
            cell.goodsDescribe1_1.textColor = RGBCOLORA(114, 172, 74, 1);
            cell.goodsDescribe1_2.hidden = YES;
        }
        if (![[proHeatDatas[1] objectForKey:@"IsDirect"] boolValue]) {
            cell.goodsDescribe2_1.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
            cell.goodsDescribe2_1.layer.borderWidth = 1;
            cell.goodsDescribe2_1.layer.cornerRadius = 8;
            cell.goodsDescribe2_1.text = @"进";
            cell.goodsDescribe2_1.textColor = RGBCOLORA(114, 172, 74, 1);
            cell.goodsDescribe2_2.hidden = YES;
        }
        if (![[proHeatDatas[2] objectForKey:@"IsDirect"] boolValue]) {
            cell.goodsDescribe3_1.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
            cell.goodsDescribe3_1.layer.borderWidth = 1;
            cell.goodsDescribe3_1.layer.cornerRadius = 8;
            cell.goodsDescribe3_1.text = @"进";
            cell.goodsDescribe3_1.textColor = RGBCOLORA(114, 172, 74, 1);
            cell.goodsDescribe3_2.hidden = YES;
        }
        if (![[proHeatDatas[3] objectForKey:@"IsDirect"] boolValue]) {
            cell.goodsDescribe4_1.layer.borderColor = RGBCOLORA(114, 172, 74, 1).CGColor;
            cell.goodsDescribe4_1.layer.borderWidth = 1;
            cell.goodsDescribe4_1.layer.cornerRadius = 8;
            cell.goodsDescribe4_1.text = @"进";
            cell.goodsDescribe4_1.textColor = RGBCOLORA(114, 172, 74, 1);
            cell.goodsDescribe4_2.hidden = YES;
        }
        if (![[proHeatDatas[0] objectForKey:@"IsImport"] boolValue]) {
            cell.goodsDescribe1_1.hidden = YES;
        }
        if (![[proHeatDatas[1] objectForKey:@"IsImport"] boolValue]) {
            cell.goodsDescribe2_1.hidden = YES;
        }
        if (![[proHeatDatas[2] objectForKey:@"IsImport"] boolValue]) {
            cell.goodsDescribe3_1.hidden = YES;
        }
        if (![[proHeatDatas[3] objectForKey:@"IsImport"] boolValue]) {
            cell.goodsDescribe4_1.hidden = YES;
        }
        cell.goodsDescribe1_3.hidden = YES;
        cell.goodsDescribe2_3.hidden = YES;
        cell.goodsDescribe3_3.hidden = YES;
        cell.goodsDescribe4_3.hidden = YES;
        
        cell.goodsMessage1.text = [proHeatDatas[0] objectForKey:@"Size"];
        cell.goodsMessage2.text = [proHeatDatas[1] objectForKey:@"Size"];
        cell.goodsMessage3.text = [proHeatDatas[2] objectForKey:@"Size"];
        cell.goodsMessage4.text = [proHeatDatas[3] objectForKey:@"Size"];
        
        cell.goodsPrice1.text = [NSString stringWithFormat:@"￥%@",[proHeatDatas[0] objectForKey:@"Price"]];
        cell.goodsPrice2.text = [NSString stringWithFormat:@"￥%@",[proHeatDatas[1] objectForKey:@"Price"]];
        cell.goodsPrice3.text = [NSString stringWithFormat:@"￥%@",[proHeatDatas[2] objectForKey:@"Price"]];
        cell.goodsPrice4.text = [NSString stringWithFormat:@"￥%@",[proHeatDatas[3] objectForKey:@"Price"]];

        cell.goodsOldPrice1.hidden = YES;
        cell.goodsOldPrice2.hidden = YES;
        cell.goodsOldPrice3.hidden = YES;
        cell.goodsOldPrice4.hidden = YES;
//        /**
//         老价格加下划线
//         **/
//        NSString *oldPrice = @"¥ 99.9";
//        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
//        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
//        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, oldPrice.length)];
//        [cell.goodsOldPrice1 setAttributedText:attri];
//        [cell.goodsOldPrice2 setAttributedText:attri];
//        [cell.goodsOldPrice3 setAttributedText:attri];
//        [cell.goodsOldPrice4 setAttributedText:attri];

        
        [cell.addShoppingCartButton1 addTarget:self action:@selector(footAddShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addShoppingCartButton2 addTarget:self action:@selector(footAddShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addShoppingCartButton3 addTarget:self action:@selector(footAddShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addShoppingCartButton4 addTarget:self action:@selector(footAddShoppingCartButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsButton1 addTarget:self action:@selector(footGoodsButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsButton2 addTarget:self action:@selector(footGoodsButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsButton3 addTarget:self action:@selector(footGoodsButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goodsButton4 addTarget:self action:@selector(footGoodsButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.allGoodsButton addTarget:self action:@selector(allGoodsButton:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    
}
#pragma mark 合作商家底部热卖加入购物车
-(void)footAddShoppingCartButton:(UIButton *)sender{
    CrossSellingTableViewCell *cell = (CrossSellingTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:13 inSection:0]];
    
    switch (sender.tag) {
        case 0:
            NSLog(@"加入购物车0");
            [self addProductsAnimation:cell.goodsImage1 selfView:self.view pointX:SCREENWIDTH/10*7 pointY:SCREENHTIGHT-40];
            break;
        case 1:
            NSLog(@"加入购物车1");
            [self addProductsAnimation:cell.goodsImage2 selfView:self.view pointX:SCREENWIDTH/10*7 pointY:SCREENHTIGHT-40];
            break;
        case 2:
            NSLog(@"加入购物车2");
            [self addProductsAnimation:cell.goodsImage3 selfView:self.view pointX:SCREENWIDTH/10*7 pointY:SCREENHTIGHT-40];
            break;
        case 3:
            NSLog(@"加入购物车3");
            [self addProductsAnimation:cell.goodsImage4 selfView:self.view pointX:SCREENWIDTH/10*7 pointY:SCREENHTIGHT-40];
            break;
        default:
            break;
    }
}
-(void)footGoodsButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    switch (sender.tag) {
        case 0:
            [goodsDetailsVC setGetID:proHeatDatas[0]];
            break;
        case 1:
            [goodsDetailsVC setGetID:proHeatDatas[1]];
            break;
        case 2:
            [goodsDetailsVC setGetID:proHeatDatas[2]];
            break;
        case 3:
            [goodsDetailsVC setGetID:proHeatDatas[3]];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
-(void)allGoodsButton:(UIButton *)sender{
    NSLog(@"获取全部商品");
}
#pragma mark 分类图片点击事件
-(void)classButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    dairyCakeViewController *dairyCakeVC = [stroyBoard instantiateViewControllerWithIdentifier:@"dairyCakeViewController"];
    drinkWineViewController *drinkWineVC = [stroyBoard instantiateViewControllerWithIdentifier:@"drinkWineViewController"];
    theBrandOfCigarettesViewController *theBrandoOfCigarettesVC = [stroyBoard instantiateViewControllerWithIdentifier:@"theBrandOfCigarettesViewController"];
    leisureSnacksViewController *leisureSnacksVC = [stroyBoard instantiateViewControllerWithIdentifier:@"leisureSnacksViewController"];
    convenientFastFoodViewController *convenientFastFoodVC = [stroyBoard instantiateViewControllerWithIdentifier:@"convenientFastFoodViewController"];
    deliciousIceCreamViewController *deliciousIceCreamVC = [stroyBoard instantiateViewControllerWithIdentifier:@"deliciousIceCreamViewController"];
    wineViewController *wineVC = [stroyBoard instantiateViewControllerWithIdentifier:@"wineViewController"];

    if (sender.tag == 0) {
        freshFruitViewController *freshFruitVC = [[freshFruitViewController alloc] initWithNibName:@"freshFruitViewController"   bundle:nil];
        [freshFruitVC setGetDatas:indexDatas[sender.tag]];
        [self.navigationController pushViewController:freshFruitVC animated:YES];
    }
    if (sender.tag == 1) {
        braisedFoodViewController *braisedFoodVC = [[braisedFoodViewController alloc] initWithNibName:@"braisedFoodViewController"   bundle:nil];
        [braisedFoodVC setGetDatas:indexDatas[sender.tag]];
        [self.navigationController pushViewController:braisedFoodVC animated:YES];
    }
    if (sender.tag == 2) {
        [dairyCakeVC setGetDatas:indexDatas[sender.tag]];
        [self.navigationController pushViewController:dairyCakeVC animated:YES];
    }
    if (sender.tag == 3) {
        [drinkWineVC setGetDatas:indexDatas[sender.tag]];
        [self.navigationController pushViewController:drinkWineVC animated:YES];
    }
    if (sender.tag == 4) {
        [theBrandoOfCigarettesVC setGetDatas:indexDatas[sender.tag]];
        [self.navigationController pushViewController:theBrandoOfCigarettesVC animated:YES];
    }
    if (sender.tag == 5) {
        [leisureSnacksVC setGetDatas:indexDatas[sender.tag]];
        [self.navigationController pushViewController:leisureSnacksVC animated:YES];
    }
    if (sender.tag == 6) {
        [convenientFastFoodVC setGetDatas:indexDatas[sender.tag]];
        [self.navigationController pushViewController:convenientFastFoodVC animated:YES];
    }
    if (sender.tag == 7) {
        [deliciousIceCreamVC setGetDatas:indexDatas[sender.tag]];
        [self.navigationController pushViewController:deliciousIceCreamVC animated:YES];
    }
    if (sender.tag == 8) {
        [wineVC setGetDatas:indexDatas[sender.tag]];
        [self.navigationController pushViewController:wineVC animated:YES];
    }
}
#pragma mark 商品点击事件
-(void)goodsButton1:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    if ([[indexDatas[sender.tag] objectForKey:@"ActType"] intValue] == 1){
        [goodsDetailsVC setGetID:[indexDatas[sender.tag] objectForKey:@"CompanyProduct"][0]];
    }else{
        [goodsDetailsVC setGetID:[indexDatas[sender.tag] objectForKey:@"FreshCompany"][0]];
    }
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
-(void)goodsButton2:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    if ([[indexDatas[sender.tag] objectForKey:@"ActType"] intValue] == 1){
        [goodsDetailsVC setGetID:[indexDatas[sender.tag] objectForKey:@"CompanyProduct"][1]];
    }else{
        [goodsDetailsVC setGetID:[indexDatas[sender.tag] objectForKey:@"FreshCompany"][1]];
    }
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
-(void)goodsButton3:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    if ([[indexDatas[sender.tag] objectForKey:@"ActType"] intValue] == 1){
        [goodsDetailsVC setGetID:[indexDatas[sender.tag] objectForKey:@"CompanyProduct"][2]];
    }else{
        [goodsDetailsVC setGetID:[indexDatas[sender.tag] objectForKey:@"FreshCompany"][2]];
    }
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
}
#pragma mark 添加商品进购物车点击事件
-(void)addShoppingCartButton1:(UIButton *)sender{
    goodsProjectTableViewCell *cell = (goodsProjectTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag+4 inSection:0]];

    [self addProductsAnimation:cell.goodsImage1 selfView:self.view pointX:SCREENWIDTH/10*7 pointY:SCREENHTIGHT-40];
}
-(void)addShoppingCartButton2:(UIButton *)sender{
    goodsProjectTableViewCell *cell = (goodsProjectTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag+4 inSection:0]];
    
    [self addProductsAnimation:cell.goodsImage2 selfView:self.view pointX:SCREENWIDTH/10*7 pointY:SCREENHTIGHT-40];}
-(void)addShoppingCartButton3:(UIButton *)sender{
    goodsProjectTableViewCell *cell = (goodsProjectTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag+4 inSection:0]];
    
    [self addProductsAnimation:cell.goodsImage3 selfView:self.view pointX:SCREENWIDTH/10*7 pointY:SCREENHTIGHT-40];}
#pragma mark 更多点击事件
-(void)moreButton:(UIButton *)sender{
    NSLog(@"MORE%ld",(long)sender.tag);
}

#pragma mark 促销点击事件
-(void)salesPromotionClick:(UIButton *)sender{
    NSLog(@"促销");
}
#pragma mark 热卖的3件商品点击事件
-(void)classClick:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    appleViewController *appleVC = [stroyBoard instantiateViewControllerWithIdentifier:@"appleViewController"];
    ChenHempViewController *chenHempVC = [stroyBoard instantiateViewControllerWithIdentifier:@"ChenHempViewController"];

    if (sender.tag == 0) {
        [appleVC setGetDatas:sevenDatas[0]];
        [self.navigationController pushViewController:appleVC animated:YES];
    }else if (sender.tag == 1) {
        lotteViewController *lotteVC = [[lotteViewController alloc] initWithNibName:@"lotteViewController"   bundle:nil];
        [lotteVC setGetDatas:sevenDatas[1]];
        [self.navigationController pushViewController:lotteVC animated:YES];

    }else if (sender.tag == 2) {
        [chenHempVC setGetDatas:sevenDatas[2]];
        [self.navigationController pushViewController:chenHempVC animated:YES];
    }
}
#pragma mark 分类的4个  点击事件
-(void)buttonClick:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    germanBeerViewController *germanBeerVC = [stroyBoard instantiateViewControllerWithIdentifier:@"germanBeerViewController"];
    cocktailViewController *cocktailVC = [stroyBoard instantiateViewControllerWithIdentifier:@"cocktailViewController"];
    snackFoodCarnivalSeasonViewController *snackFoodCarnivalSeasonVC = [stroyBoard instantiateViewControllerWithIdentifier:@"snackFoodCarnivalSeasonViewController"];
    articlesForDailyUseViewController *articlesForDailyUseVC = [stroyBoard instantiateViewControllerWithIdentifier:@"articlesForDailyUseViewController"];

    switch (sender.tag) {
        case 0:
            [germanBeerVC setGetDatas:sevenDatas[3]];
            [self.navigationController pushViewController:germanBeerVC animated:YES];
            break;
        case 1:
            [cocktailVC setGetDatas:sevenDatas[4]];
            [self.navigationController pushViewController:cocktailVC animated:YES];
            break;
        case 2:
            [snackFoodCarnivalSeasonVC setGetDatas:sevenDatas[5]];
            [self.navigationController pushViewController:snackFoodCarnivalSeasonVC animated:YES];
            break;
        case 3:
            [articlesForDailyUseVC setGetDatas:sevenDatas[6]];
            [self.navigationController pushViewController:articlesForDailyUseVC animated:YES];
            break;
        default:
            break;
    }
}
#pragma mark 顶部分类展示图标
-(void)headClassButton:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    newProductViewController *newProductVC = [stroyBoard instantiateViewControllerWithIdentifier:@"newProductViewController"];
    salesPromotionViewController *salesPromotionVC = [stroyBoard instantiateViewControllerWithIdentifier:@"salesPromotionViewController"];

    switch (sender.tag) {
        case 0:
            [self.navigationController pushViewController:newProductVC animated:YES];
            break;
        case 1:
            [self performSegueWithIdentifier:@"baseViewToLuckDraw" sender:self];
            break;
        case 2:
            [self.navigationController pushViewController:salesPromotionVC animated:YES];
            break;
        case 3:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToFlashSmallSupper" object:nil];
            break;
        default:
            break;
    }
}

#pragma mark - SDCycleScrollViewDelegate 点击轮播图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    taiwaneseFoodViewController *taiwaneseFoodVC = [stroyBoard instantiateViewControllerWithIdentifier:@"taiwaneseFoodViewController"];
    CassegrainWineryViewController *cassegrainWinerVC = [stroyBoard instantiateViewControllerWithIdentifier:@"CassegrainWineryViewController"];

    if (index == 0) {
        [taiwaneseFoodVC setGetDatas:scrollDatas[index]];
        [self.navigationController pushViewController:taiwaneseFoodVC animated:YES];
    }else if(index == 1){
        aDishThatGoesWithLiquorViewController *freshFruitVC = [[aDishThatGoesWithLiquorViewController alloc] initWithNibName:@"aDishThatGoesWithLiquorViewController"   bundle:nil];
        [freshFruitVC setGetDatas:scrollDatas[index]];
        [self.navigationController pushViewController:freshFruitVC animated:YES];
    }else{
        [cassegrainWinerVC setGetDatas:scrollDatas[index]];
        [self.navigationController pushViewController:cassegrainWinerVC animated:YES];
    }
}

#pragma mark 新手引导图
-(void)initGuideView{
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHTIGHT)];
    [backView setBackgroundColor:[UIColor blackColor]];
    backView.alpha = 0.6;
    
    guiView = [[NSBundle mainBundle] loadNibNamed:@"guideView" owner:self options:nil][0];
    [guiView setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHTIGHT)];
    [guiView.removeViewClick addTarget:self action:@selector(removeViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:backView];
    [self.navigationController.view addSubview:guiView];
}
#pragma mark 关闭新手引导页
-(void)removeViewClick:(UIButton *)sender{
    [backView removeFromSuperview];
    [guiView removeFromSuperview];
}
#pragma mark 选地址
- (IBAction)loginAddress:(id)sender {
    if ([[USERDEFAULTS objectForKey:@"isRegister"] integerValue]) {
        [self performSegueWithIdentifier:@"baseViewToAddress" sender:self];
    }else{
        VerifyTheMobilePhoneViewController *VerifyTheMobilePhoneVC = [[VerifyTheMobilePhoneViewController alloc] initWithNibName:@"VerifyTheMobilePhoneViewController"   bundle:nil];
        [self.navigationController pushViewController:VerifyTheMobilePhoneVC animated:YES];
    }

}
- (IBAction)changeAddressClick:(id)sender {
    [self performSegueWithIdentifier:@"baseViewToAddress" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"baseViewToAddress"]) {
        addressManageViewController *addressManageVC = segue.destinationViewController;
        addressManageVC.delegate = self;
    }
}
#pragma mark 地址管理定位当前位置返回重新获取坐标
-(void)positioningBackView:(NSString *)sender{
    if ([sender isEqualToString:@"0"]) {
        [self getCurrentAddress];
    }else if([sender isEqualToString:@"1"]){
//        [_titleAddress setTitle:[USERDEFAULTS objectForKey:@"CurrentAddress"] forState:UIControlStateNormal];
//        [self getStores:[USERDEFAULTS objectForKey:@"CurrentLatitude"] lon:[USERDEFAULTS objectForKey:@"CurrentLongitude"]];
//        [self initAddressTitleWidth:[USERDEFAULTS objectForKey:@"CurrentAddress"]];

    }
}
#pragma mark 重置titleAddress宽度
-(void)initAddressTitleWidth:(NSString *)str{
    CGSize titleSize =[str  boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size;
    if (titleSize.width > SCREENWIDTH-170) {
        _titleAddressWidth.constant = SCREENWIDTH-170;
    }else{
        _titleAddressWidth.constant = titleSize.width;
    }
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
- (NSMutableArray<CALayer *> *)animationLayers {
    
    if (!_animationLayers) {
        
        _animationLayers = [NSMutableArray array];
    }
    
    return _animationLayers;
}


/**
 *  添加商品到购物车的动画
 *
 *  @param imageView 商品的图片
 */
- (void)addProductsAnimation:(UIImageView *)imageView selfView:(UIView *)selfView pointX:(float) pointX pointY:(float)pointY{
    
    CGRect frame = [imageView convertRect:imageView.bounds toView:selfView];
    
    CALayer *transitionLayer = [CALayer layer];
    transitionLayer.frame = frame;
    transitionLayer.contents = imageView.layer.contents;
    
    [selfView.layer addSublayer:transitionLayer];
    [self.animationLayers addObject:transitionLayer];
    
    CGPoint p1 = transitionLayer.position;
    CGPoint p3 = CGPointMake(pointX, pointY);
    
    CAKeyframeAnimation *positonAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, p1.x, p1.y);
    CGPathAddCurveToPoint(path, nil, p1.x, p1.y - 120, p3.x, p1.y - 120, p3.x, p3.y);
    positonAnimation.path = path;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.9);
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = YES;
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 1.0)];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[positonAnimation,opacityAnimation,transformAnimation];
    groupAnimation.duration = 0.6;
    groupAnimation.delegate = self;
    
    [transitionLayer addAnimation:groupAnimation forKey:@"addProducts"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (self.animationLayers.count > 0) {
        
        CALayer *transitionLayer = [self.animationLayers lastObject];
        transitionLayer.hidden = YES;
        [transitionLayer removeFromSuperlayer];
        [self.animationLayers removeLastObject];
        
//        [self.view.layer removeAnimationForKey:@"addProducts"];
    }
}

@end
