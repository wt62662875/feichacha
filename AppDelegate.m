//
//  AppDelegate.m
//  feichacha
//
//  Created by wt on 16/4/21.
//  Copyright © 2016年 wangtao. All rights reserved.
//  百度地图QPXoo4yamC4XuEEOTdbhj3BI4uBwTnsD
//　　　　　　　 ┏┓    ┏┓+ +
//　　　　　　　┏┛┻━━ ━┛┻┓ + +
//　　　　　　　┃        ┃
//　　　　　　　┃   ━    ┃ ++ + + +
//　　　　　　 ████━████  ┃+
//　　　　　　　┃　　　　　┃ +
//　　　　　　　┃   ┻　　 ┃
//　　　　　　　┃　　　　　┃ + +
//　　　　　　　┗━┓　　 ┏━┛
//　　　　　　　  ┃　　 ┃
//　　　　　　　  ┃　　 ┃ + + + +
//　　　　　　　  ┃　　 ┃　　　　Code is far away from bug with the mythical animal protecting
//　　　　　　　  ┃　　 ┃ + 　　　　神兽保佑,永无bug
//　　　　　　　  ┃　　 ┃
//　　　　　　　  ┃　　 ┃　　+
//　　　　　　　  ┃　   ┗━━━┓ + +
//　　　　　　　  ┃ 　　　   ┣┓
//　　　　　　　  ┃ 　　　  ┏┛
//　　　　　　　  ┗┓┓┏━┳┓┏┛ + + + +
//　　　　　　　   ┃┫┫ ┃┫┫
//　　　　　　　   ┗┻┛ ┗┻┛+ + + +
//
#import "AppDelegate.h"
#import "luanchViewController.h"
#import "tabBarViewController.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#include <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "paymentStatusViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//新浪微博SDK头文件
#import "WeiboSDK.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [USERDEFAULTS setObject:nil forKey:@"CurrentLongitude"];
    [USERDEFAULTS setObject:nil forKey:@"CurrentLatitude"];

    // Override point for customization after application launch.
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
//         NSLog(@"第一次启动");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        UIStoryboard *stroyBoard = GetStoryboard(@"Main");
        luanchViewController *luanchVC = [stroyBoard instantiateViewControllerWithIdentifier:@"luanchViewController"];
        self.window.rootViewController = luanchVC;
        }else{
//         NSLog(@"不是第一次启动");
            UIStoryboard *stroyBoard = GetStoryboard(@"Main");
            UINavigationController *rootnacigation = [stroyBoard instantiateViewControllerWithIdentifier:@"rootNavigationController"];
            self.window.rootViewController = rootnacigation;
            
        }
    
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"QPXoo4yamC4XuEEOTdbhj3BI4uBwTnsD"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    //推送
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:@"3488fa05324bfc53c0e19e93" channel:@"App Store" apsForProduction:NO advertisingIdentifier:advertisingId];
    
    //向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:@"wxfbd72a1955031c01" withDescription:@"feichacha"];
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"122b1c99d67ac"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1989913719"
                                           appSecret:@"299ead77626d0caf39fd6b9cf891227f"
                                         redirectUri:@"http://manage.feichacha.com/html/shop/index.html"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105477185"
                                      appKey:@"uo91MAqrRgiFLVGc"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
            default:
                 break;
         }
     }];


    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required -    DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error
          );
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        NSString *str = [url.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSLog(@"%@",dic);
        
        UINavigationController *ctrl = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        paymentStatusViewController *paymentStatusVC = [[paymentStatusViewController alloc] initWithNibName:@"paymentStatusViewController"   bundle:nil];

        if ([dic[@"memo"][@"ResultStatus"] isEqualToString:@"9000"]) {
            [paymentStatusVC setPayState:@"1"];
            [ctrl pushViewController:paymentStatusVC animated:YES];
        }else if ([dic[@"memo"][@"ResultStatus"] isEqualToString:@"6001"]){
            [paymentStatusVC setPayState:@"0"];
            [ctrl pushViewController:paymentStatusVC animated:YES];
            
        }

        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//        【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
        NSLog(@"=====%@",[resultDic[@"resultStatus"] class]);
        NSLog(@"result == %@",[resultDic[@"resultStatus"] class]);
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            //NSLog(@"result == %@",resultDic);
            
        }];
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    //    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
    //        if (_delegate
    //            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
    //            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
    //            [_delegate managerDidRecvMessageResponse:messageResp];
    //        }
    //    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
    //        if (_delegate
    //            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
    //            SendAuthResp *authResp = (SendAuthResp *)resp;
    //            [_delegate managerDidRecvAuthResponse:authResp];
    //        }
    //    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
    //        if (_delegate
    //            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
    //            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
    //            [_delegate managerDidRecvAddCardResponse:addCardResp];
    //        }
    //    }else
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        UINavigationController *ctrl = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        paymentStatusViewController *paymentStatusVC = [[paymentStatusViewController alloc] initWithNibName:@"paymentStatusViewController"   bundle:nil];
        
        switch (resp.errCode) {
            case WXSuccess:
                [paymentStatusVC setPayState:@"1"];
                [ctrl pushViewController:paymentStatusVC animated:YES];
                break;
                
            default:
               [paymentStatusVC setPayState:@"0"];
               [ctrl pushViewController:paymentStatusVC animated:YES];
                break;
        }

    }
    
}

@end
