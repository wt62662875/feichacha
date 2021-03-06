//
//  Public.h
//  LiuLiuGanXi_User
//
//  Created by wt on 15/4/2.
//  Copyright (c) 2015年 Fslit. All rights reserved.
//
//320     375   414
#pragma    isRegister   是否登陆   1登陆   0未登录
#pragma    shopID   当前所选店铺ID
#pragma    telPhoneNumber   电话
#pragma    UserID     用户ID
#pragma    DeliveryType  1送货上门  2自提

#pragma    delectDetailedAddress   选中详细地址
#pragma    CurrentAddress   当前地址
#pragma    CurrentLongitude   当前经度
#pragma    CurrentLatitude   当前纬度

#pragma    FlashShoppingCartGoods           购物车闪送商品
#pragma    ReservationShoppingCartGoods     购物车预定商品
#pragma    PurchaseQuantity                 购买量

#pragma    OrderNumber                 订单号

#pragma    ChooseClass                 首页-更多  跳转倒闪送小超


#import "AppUtils.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "IQKeyboardManager.h"
#import "SDCycleScrollView.h"
#import "UIAlertView+Blocks.h"
#import "AFHTTPSessionManager.h"


#ifndef LiuLiuGanXi_Operation_Public_h
#define LiuLiuGanXi_Operation_Public_h


#endif

#define SeviceURL @"http://api.feichacha.com/api"
#define IMGURL @"http://manage.feichacha.com"


//#define SeviceURL @"http://192.168.1.150:996"

#define RGBCOLORA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define TOKEN [USERDEFAULTS objectForKey:@"TOKEN"]
#define X_CLIENT_TOKEN @"Authorization"

// 黄色/
#define YELLOW_COLOR	RGBCOLORA(194,143,95,1)
// view灰背景色
#define BACKGROUND_DARK_COLOR	RGBCOLORA(242,240,240,1)
// 背景色/
#define BACKGROUND_COLOR	RGBCOLORA(255,255,255,1)

#define SCREENWIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREENHTIGHT [[UIScreen mainScreen]bounds].size.height

#define BULE RGBCOLORA(65,204,239,1)

#define GetStoryboard(StoryboardName)  [UIStoryboard storyboardWithName:(StoryboardName) bundle:[NSBundle mainBundle]];

#define USERDEFAULTS  [NSUserDefaults standardUserDefaults]