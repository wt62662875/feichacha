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
#import "submitOrdersViewController.h"

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
        submitOrdersViewController *payVC=(submitOrdersViewController *)ctrl.topViewController;
        if ([dic[@"memo"][@"ResultStatus"] isEqualToString:@"9000"]) {
//            [payVC setSuccessFor_pay];
        }else if ([dic[@"memo"][@"ResultStatus"] isEqualToString:@"6001"]){
//            [payVC setFalseFor_Pay];
            
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
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

@end
