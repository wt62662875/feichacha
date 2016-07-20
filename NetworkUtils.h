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
 *  @param lat      经度
 *  @param lon      纬度
 *  @param Type     0:最近的一家公司，1：最近的公司列表
 *  @param success  成功回调
 *  @param faileure 失败回调
 */
-(void)companyDetail:(NSString *)lat lon:(NSString *)lon Type:(NSString*)Type success:(SuccessBlock)success failure:(FailureBlock)faileure;

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
 *  @param page        分页
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)ClassProductList:(NSString *)compnayId classId:(NSString *)classId page:(NSString *)page success:(SuccessBlock)success failure:(FailureBlock)faileure;

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

/**
 *  商品详情
 *
 *  @param FGuId       商品ID
 *  @param ActType     商品类型         1闪送小超 2新鲜预定
 *  @param IsAct       是否活动商品      0不是活动商品  1是活动商品
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)ProDetail:(NSString *)FGuId ActType:(NSString *)ActType IsAct:(NSString*)IsAct success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  获取用户地址信息列表
 *
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)userAddressList:(NSString *)lat lon:(NSString*)lon success:(SuccessBlock)success failure:(FailureBlock)faileure;
/**
 *  获取地址信息详情
 *
 *  @param FGuId       地址ID
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)addressDetails:(NSString *)addID success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  查询城市列表
 *
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)areasList:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  更新用户地址详细信息
 *
 *  @param Id           地址Id
 *  @param lat          经度
 *  @param lon          纬度
 *  @param Address      详细地址
 *  @param Sex          性别          true 男，false 女
 *  @param Mobile       电话号码
 *  @param Tablet       门牌号
 *  @param Name         姓名
 *  @param IsDefault    是否默认       true 默认，false 非默认
 *  @param CityId       城市Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)upDateAddress:(NSString *)Id lat:(NSString *)lat lon:(NSString *)lon Address:(NSString *)Address Sex:(NSString *)Sex Mobile:(NSString *)Mobile Tablet:(NSString *)Tablet Name:(NSString *)Name IsDefault:(NSString *)IsDefault CityId:(NSString *)CityId success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  添加用户地址详细信息
 *
 *  @param lat          经度
 *  @param lon          纬度
 *  @param Address      详细地址
 *  @param Sex          性别          true 男，false 女
 *  @param Mobile       电话号码
 *  @param Tablet       门牌号
 *  @param Name         姓名
 *  @param IsDefault    是否默认       true 默认，false 非默认
 *  @param CityId       城市Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)insertAddress:(NSString *)lat lon:(NSString *)lon Address:(NSString *)Address Sex:(NSString *)Sex Mobile:(NSString *)Mobile Tablet:(NSString *)Tablet Name:(NSString *)Name IsDefault:(NSString *)IsDefault CityId:(NSString *)CityId success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  删除用户地址详细信息
 *
 *  @param Id          地址ID
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)delAddress:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  获取首页轮播图
 *
 *  @param Id          商店Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)scrollList:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  首页置顶7条数据
 *
 *  @param Id          商店Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)sevenList:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  首页活动列表
 *
 *  @param Id          商店Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)indexList:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  首页获取叉叉热卖商品
 *
 *  @param Id          商店Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)proHeat:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  新鲜预定头部活动接口
 *
 *  @param compnayId   商店Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)FreshScroll:(NSString *)compnayId success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  新鲜预定页面中部接口
 *
 *  @param compnayId   商店Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)FreshList:(NSString *)compnayId success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  获取新品列表
 *
 *  @param compnayId   商店Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)newList:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  获取促销列表
 *
 *  @param compnayId   商店Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)PromotionsList:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  查询活动详情
 *
 *  @param ActivityId   活动Id
 *  @param ActType      商品类型    1闪送小超 2新鲜预定
 *  @param success      成功回调
 *  @param faileure     失败回调
 */
-(void)ActivityList:(NSString *)ActivityId ActType:(NSString *)ActType success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  检测商店是否包含购物车商品
 *
 *  @param CompanyId    商店Id
 *  @param OrderType    1闪送小超订单，2新鲜预定订单
 *  @param OrderList    商品集合  FguId=商品Fguid
 *  @param success      成功回调
 *  @param faileure     失败回调
 */
-(void)CompareOrderList:(NSString *)CompanyId OrderType:(NSString *)OrderType OrderList:(NSArray *)OrderList success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  凑单
 *
 *  @param Id           商店ID
 *  @param Library      商品类型    1闪送小超 2新鲜预定
 *  @param Maxmoney     最大价格
 *  @param Minmoney     最小价格
 *  @param success      成功回调
 *  @param faileure     失败回调
 */
-(void)MinatoList:(NSString *)Id Library:(NSString *)Library Maxmoney:(NSString *)Maxmoney Minmoney:(NSString *)Minmoney success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  获取我今天的中奖信息
 *
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)UserLucky:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  提交订单
 *
 *  @param UserId       用户Id
 *  @param CompanyId    商店Id
 *  @param Type         1支付宝，2微信，4货到付款
 *  @param CouponId     优惠券Id
 *  @param IsCoupon     是否使用优惠券
 *  @param AddId        收货地址Id
 *  @param Remark       备注
 *  @param OrderType    1闪送小超订单，2新鲜预定订单
 *  @param PresetTime   预定送货时间 默认当前时间送达
 *  @param OrderList    商品集合  ProductId=商品Id   ProductCount=商品数量    SumMoney=商品总价
 *  @param success      成功回调
 *  @param faileure     失败回调
 */
-(void)SubmitOrder:(NSString *)UserId CompanyId:(NSString *)CompanyId Type:(NSString *)Type CouponId:(NSString *)CouponId IsCoupon:(NSString *)IsCoupon AddId:(NSString *)AddId Remark:(NSString *)Remark OrderType:(NSString *)OrderType PresetTime:(NSString *)PresetTime OrderList:(NSArray *)OrderList success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  支付宝支付接口
 *
 *  @param Order        订单Id
 *  @param Type         类型：1,支付宝，2：支付宝
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)PayDes:(NSString *)Order Type:(NSString*)Type success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  获取我的所有订单
 *
 *  @param Type        获取类型，0全部，1待付款，2待收货，3待评价
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)OrderList:(NSString *)Type success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  微信支付接口
 *
 *  @param Order        订单Id
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)WxPayDes:(NSString *)Order success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  根据经纬度获取附近门店列表
 *
 *  @param lat         纬度
 *  @param lon         经度
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)StoresList:(NSString *)lat lon:(NSString *)lon success:(SuccessBlock)success failure:(FailureBlock)faileure;

/**
 *  确认收货/取消订单
 *
 *  @param OrderId     订单Id
 *  @param Type        7 取消订单 2确认收货
 *  @param success     成功回调
 *  @param faileure    失败回调
 */
-(void)ConfirmOrder:(NSString *)OrderId Type:(NSString *)Type success:(SuccessBlock)success failure:(FailureBlock)faileure;
@end
