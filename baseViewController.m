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



@interface baseViewController ()<SDCycleScrollViewDelegate,UIGestureRecognizerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    guideView *guiView;
    UIView *backView; //引导页背景
    BOOL isbool;
    
    BMKLocationService *_locService;
    BMKGeoCodeSearch * _searcher;
//    BMKPoiSearch *_searcher;
}
@property (weak, nonatomic) IBOutlet UILabel *deliveryTo;   //配送至
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *titleAddress;

/** layers */
@property(nonatomic,strong)NSMutableArray<CALayer *> *animationLayers;

@end
// 合作商家5按钮    [[NSNotificationCenter defaultCenter] postNotificationName:@"initFiveButton" object:nil];
// 非合作商家4按钮   [[NSNotificationCenter defaultCenter] postNotificationName:@"initFourButton" object:nil];
@implementation baseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initFiveButton" object:nil];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    _deliveryTo.layer.borderColor = [UIColor blackColor].CGColor;
    _deliveryTo.layer.borderWidth = 0.5;
    // Do any additional setup after loading the view.
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];

        [self initGuideView];
    }
    [self getCurrentAddress];

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
            
            [SVProgressHUD showWithStatus:@"加载中..."];
            [[NetworkUtils shareNetworkUtils] companyDetail:latString lon:lonString success:^(id responseObject) {
                NSLog(@"数据:%@",responseObject);
                if ([[responseObject objectForKey:@"ResultType"]intValue] == 0) {
                    [USERDEFAULTS setObject:[[responseObject objectForKey:@"AppendData"] objectForKey:@"Id"] forKey:@"shopID"];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后重试" maskType:SVProgressHUDMaskTypeNone];
                }
                [SVProgressHUD dismiss];
            } failure:^(NSString *error) {
                [SVProgressHUD dismiss];
            }];
            
            
            _locService.delegate = nil;
        }
        else
        {
          NSLog(@"反geo检索发送失败");    
        }
        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);


    }

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

  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}
//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    _searcher.delegate = nil;
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
        cell.shufflingView.imageURLStringsGroup = [[NSArray alloc]initWithObjects:@"http://manage.feichacha.com/html/shop/images/index_banner_top1.jpg",@"http://manage.feichacha.com/html/shop/images/index_banner_top2.jpg",@"http://manage.feichacha.com/html/shop/images/index_banner_top5.jpg", nil];
        cell.shufflingView.placeholderImage = [UIImage imageNamed:@"bg.png"];
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
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg1.jpg"]];
        [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg2.jpg"]];
        [cell.goodsImage3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg3.jpg"]];
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
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg4.png"]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg5.png"]];
        [cell.image3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg6.png"]];
        [cell.image4 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/gg7.png"]];
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
        
        if (indexPath.row == 4) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom1.jpg"]];
        }else if(indexPath.row == 5) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom2.jpg"]];
        }else if(indexPath.row == 6) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom3.jpg"]];
        }else if(indexPath.row == 7) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom4.jpg"]];
        }else if(indexPath.row == 8) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom5.jpg"]];
        }else if(indexPath.row == 9) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom6.jpg"]];
        }else if(indexPath.row == 10) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom7.jpg"]];
        }else if(indexPath.row == 11) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom8.jpg"]];
        }else if(indexPath.row == 12) {
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_banner_bottom9.jpg"]];
        }
        
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_img1.png"]];
        [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_img2.png"]];
        [cell.goodsImage3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_img3.png"]];
        
        /**
         老价格加下划线
         **/
        NSString *oldPrice = @"¥ 99.9";
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, oldPrice.length)];
        [cell.goodsOldPrice1 setAttributedText:attri];
        [cell.goodsOldPrice2 setAttributedText:attri];
        [cell.goodsOldPrice3 setAttributedText:attri];

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
        [cell.goodsImage1 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_img2.png"]];
        [cell.goodsImage2 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_img2.png"]];
        [cell.goodsImage3 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_img2.png"]];
        [cell.goodsImage4 sd_setImageWithURL:[NSURL URLWithString:@"http://manage.feichacha.com/html/shop/images/index_img2.png"]];

        /**
         老价格加下划线
         **/
        NSString *oldPrice = @"¥ 99.9";
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPrice.length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, oldPrice.length)];
        [cell.goodsOldPrice1 setAttributedText:attri];
        [cell.goodsOldPrice2 setAttributedText:attri];
        [cell.goodsOldPrice3 setAttributedText:attri];
        [cell.goodsOldPrice4 setAttributedText:attri];

        
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
    switch (sender.tag) {
        case 0:
            NSLog(@"商品点击0");
            break;
        case 1:
            NSLog(@"商品点击1");
            break;
        case 2:
            NSLog(@"商品点击2");
            break;
        case 3:
            NSLog(@"商品点击3");
            break;
        default:
            break;
    }
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
        [self.navigationController pushViewController:freshFruitVC animated:YES];
    }
    if (sender.tag == 1) {
        braisedFoodViewController *braisedFoodVC = [[braisedFoodViewController alloc] initWithNibName:@"braisedFoodViewController"   bundle:nil];
        [self.navigationController pushViewController:braisedFoodVC animated:YES];
    }
    if (sender.tag == 2) {
        [self.navigationController pushViewController:dairyCakeVC animated:YES];
    }
    if (sender.tag == 3) {
        [self.navigationController pushViewController:drinkWineVC animated:YES];
    }
    if (sender.tag == 4) {
        [self.navigationController pushViewController:theBrandoOfCigarettesVC animated:YES];
    }
    if (sender.tag == 5) {
        [self.navigationController pushViewController:leisureSnacksVC animated:YES];
    }
    if (sender.tag == 6) {
        [self.navigationController pushViewController:convenientFastFoodVC animated:YES];
    }
    if (sender.tag == 7) {
        [self.navigationController pushViewController:deliciousIceCreamVC animated:YES];
    }
    if (sender.tag == 8) {
        [self.navigationController pushViewController:wineVC animated:YES];
    }
//    NSLog(@"分类图片%ld",(long)sender.tag);
}
#pragma mark 商品点击事件
-(void)goodsButton1:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setTest:@"111"];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
    
    
    NSLog(@"商品点击%ld",(long)sender.tag);
}
-(void)goodsButton2:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setTest:@"111"];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
    
    
    NSLog(@"商品点击%ld",(long)sender.tag);
}
-(void)goodsButton3:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    goodsDetailsViewController *goodsDetailsVC = [stroyBoard instantiateViewControllerWithIdentifier:@"goodsDetailsViewController"];
    [goodsDetailsVC setTest:@"111"];
    [self.navigationController pushViewController:goodsDetailsVC animated:YES];
    
    
    NSLog(@"商品点击%ld",(long)sender.tag);
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
    CassegrainWineryViewController *cassegrainWinerVC = [stroyBoard instantiateViewControllerWithIdentifier:@"CassegrainWineryViewController"];
    ChenHempViewController *chenHempVC = [stroyBoard instantiateViewControllerWithIdentifier:@"ChenHempViewController"];

    if (sender.tag == 0) {
        [self.navigationController pushViewController:appleVC animated:YES];
    }else if (sender.tag == 1) {
        [self.navigationController pushViewController:cassegrainWinerVC animated:YES];
    }else if (sender.tag == 2) {
        [self.navigationController pushViewController:chenHempVC animated:YES];
    }
}
#pragma mark 分类的4个  点击事件
-(void)buttonClick:(UIButton *)sender{
    UIStoryboard *stroyBoard = GetStoryboard(@"Main");
    germanBeerViewController *germanBeerVC = [stroyBoard instantiateViewControllerWithIdentifier:@"germanBeerViewController"];
    switch (sender.tag) {
        case 0:
            NSLog(@"分类1");
            break;
        case 1:
            NSLog(@"分类2");
            break;
        case 2:
            NSLog(@"分类3");
            break;
        case 3:
            [self.navigationController pushViewController:germanBeerVC animated:YES];
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
            NSLog(@"33333");
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
        [self.navigationController pushViewController:taiwaneseFoodVC animated:YES];
    }else if(index == 1){
        aDishThatGoesWithLiquorViewController *freshFruitVC = [[aDishThatGoesWithLiquorViewController alloc] initWithNibName:@"aDishThatGoesWithLiquorViewController"   bundle:nil];
        [self.navigationController pushViewController:freshFruitVC animated:YES];
    }else{
        [self.navigationController pushViewController:cassegrainWinerVC animated:YES];
    }
    
    NSLog(@"%ld",(long)index);
}
#pragma mark 搜索按钮
- (IBAction)serchClick:(id)sender {
    NSLog(@"serch");
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

- (IBAction)loginAddress:(id)sender {
//    [self performSegueWithIdentifier:@"baseViewToAddress" sender:self];
    VerifyTheMobilePhoneViewController *VerifyTheMobilePhoneVC = [[VerifyTheMobilePhoneViewController alloc] initWithNibName:@"VerifyTheMobilePhoneViewController"   bundle:nil];
    [self.navigationController pushViewController:VerifyTheMobilePhoneVC animated:YES];

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
