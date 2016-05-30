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

/**
 *  上传经纬度返回最近门店
 *
 *  @param lat   经度
 *  @param lon   纬度
 *  @param success  成功回调
 *  @param faileure 失败回调
 */
-(void)companyDetail:(NSString *)lat lon:(NSString *)lon success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  获取分类名称列表
 *
 *  @param success  成功回调
 *  @param faileure 失败回调
 */
-(void)listProClass:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  根据商店Id分类Id获取分类下对应的商品列表
 *
 *  @param compnayId   商店Id
 *  @param classId     分类Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)ClassProductList:(NSString *)compnayId classId:(NSString *)classId success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  根据商家Id和输入的商品关键字搜索商品列表
 *
 *  @param compnayId   商店Id
 *  @param serchStr    搜索str
 *  @param Order       价格排序：true 升序，false 降序
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)serchGoods:(NSString *)compnayId serchStr:(NSString *)serchStr Order:(NSString *)Order success:(SuccessBlock)success failure:(FailureBlock)faileure;
@end
