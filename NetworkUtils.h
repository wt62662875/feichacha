//
//  NetworkUtils.h
//  CoffeeFarmsB2C
//
//  Created by 刘冬 on 15/9/24.
//  Copyright (c) 2015年 wangtao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);

@interface NetworkUtils : NSObject

+(instancetype)shareNetworkUtils;

-(AFHTTPRequestOperationManager *)baseHtppRequest;

/**
 *  获取验证码
 *
 *  @param phoneNumber   电话号码
 *  @param success  成功回调
 *  @param faileure 失败回调
 */
-(void)getVerificationCode:(NSString *)phoneNumber success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  登录
 *
 *  @param phoneNumber   电话号码
 *  @param code   验证码
 *  @param success  成功回调
 *  @param faileure 失败回调
 */
-(void)login:(NSString *)phoneNumber code:(NSString *)code success:(SuccessBlock)success failure:(FailureBlock)faileure;




@end
