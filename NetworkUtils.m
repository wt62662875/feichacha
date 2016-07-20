//
//  NetworkUtils.m
//  CoffeeFarmsB2C
//
//  Created by 刘冬 on 15/9/24.
//  Copyright (c) 2015年 wangtao. All rights reserved.
//

#import "NetworkUtils.h"
#define TIMEOUT 20
@implementation NetworkUtils

+(instancetype)shareNetworkUtils{
    static NetworkUtils *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc]init];
    });
    return _sharedClient;
}

-(AFHTTPRequestOperationManager *)baseHtppRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;//去掉null字段
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json",@"application/x-www-form-urlencoded",@"multipart/form-data", nil];
    return manager;
}

-(void)getVerificationCode:(NSString *)phoneNumber success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/User/SendMobileMessage?mobile=%@",phoneNumber];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}
-(void)login:(NSString *)phoneNumber code:(NSString *)code success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/User/CheckCode?mobile=%@&code=%@",phoneNumber,code];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}
-(void)companyDetail:(NSString *)lat lon:(NSString *)lon Type:(NSString *)Type success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/CompanyDetail/Company?lat=%@&lon=%@&Type=%@",lat,lon,Type];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}
-(void)listProClass:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/ProClass/ListProClass?CompanyId=%@",[USERDEFAULTS objectForKey:@"shopID"]];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}
-(void)ClassProductList:(NSString *)compnayId classId:(NSString *)classId page:(NSString *)page success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/ProClass/ClassProductList?CompnayId=%@&ClassId=%@&page=%@",compnayId,classId,page];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}
-(void)serchGoods:(NSString *)compnayId serchStr:(NSString *)serchStr Order:(NSString *)Order success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Search/SearchtList"];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:compnayId,@"CompnayId",Order,@"Order",serchStr,@"str", nil];
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}
-(void)ProDetail:(NSString *)FGuId ActType:(NSString *)ActType IsAct:(NSString*)IsAct success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Product/ProDetail?FGuId=%@&ActType=%@&IsAct=%@&CompanyId=%@",FGuId,ActType,IsAct,[USERDEFAULTS objectForKey:@"shopID"]];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}
-(void)userAddressList:(NSString *)lat lon:(NSString*)lon success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:X_CLIENT_TOKEN];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Addlist/UserAddList?lat=%@&lon=%@",lat,lon];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}
-(void)addressDetails:(NSString *)addID success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/UserAdd/AddDetail?Id=%@",addID];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}
-(void)areasList:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Areas/AreasList"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)upDateAddress:(NSString *)Id lat:(NSString *)lat lon:(NSString *)lon Address:(NSString *)Address Sex:(NSString *)Sex Mobile:(NSString *)Mobile Tablet:(NSString *)Tablet Name:(NSString *)Name IsDefault:(NSString *)IsDefault CityId:(NSString *)CityId success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/UpdateAdd/UpdateAdd"];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:Id,@"Id",lat,@"lat",lon,@"lon", Address,@"Address",Sex,@"Sex",Mobile,@"Mobile",Tablet,@"Tablet",Name,@"Name",IsDefault,@"IsDefault",CityId,@"CityId",nil];
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)insertAddress:(NSString *)lat lon:(NSString *)lon Address:(NSString *)Address Sex:(NSString *)Sex Mobile:(NSString *)Mobile Tablet:(NSString *)Tablet Name:(NSString *)Name IsDefault:(NSString *)IsDefault CityId:(NSString *)CityId success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:X_CLIENT_TOKEN];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/UserAdd/InsertAdd"];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:lat,@"lat",lon,@"lon",CityId,@"CityId",Address,@"Address",Sex,@"Sex",Mobile,@"Mobile",Tablet,@"Tablet",Name,@"Name",IsDefault,@"IsDefault", nil];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)delAddress:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/DelAddress/DelAdd?Id=%@",Id];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)scrollList:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Scroll/ScrollList?Id=%@",Id];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)sevenList:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/IndexSeven/SevenList?Id=%@",Id];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)indexList:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/index/IndexList?CompanyId=%@",Id];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)proHeat:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/ProHeat/IndexHeat?CompanyId=%@",Id];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)FreshScroll:(NSString *)compnayId success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/FreshScroll/Scroll?CompanyId=%@",compnayId];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)FreshList:(NSString *)compnayId success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Fresh/FreshList?CompanyId=%@",compnayId];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)newList:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/New/NewList?Id=%@",Id];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)PromotionsList:(NSString *)Id success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Promotions/PromotionsList?Id=%@",Id];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)ActivityList:(NSString *)ActivityId ActType:(NSString *)ActType success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Activitys/ActivityList?ActivityId=%@&ActType=%@&CompanyId=%@",ActivityId,ActType,[USERDEFAULTS objectForKey:@"shopID"]];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)CompareOrderList:(NSString *)CompanyId OrderType:(NSString *)OrderType OrderList:(NSArray *)OrderList success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/CompareOrder/CompareOrderList"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:OrderList
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:CompanyId,@"CompanyId" ,OrderType,@"OrderType",jsonStr,@"OrderList",nil];
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)MinatoList:(NSString *)Id Library:(NSString *)Library Maxmoney:(NSString *)Maxmoney Minmoney:(NSString *)Minmoney success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Minato/MinatoList?Id=%@&Maxmoney=%@&Minmoney=%@&Library=%@",Id,Maxmoney,Minmoney,Library];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)UserLucky:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/UserLucky/UserLucky"];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:X_CLIENT_TOKEN];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)SubmitOrder:(NSString *)UserId CompanyId:(NSString *)CompanyId Type:(NSString *)Type CouponId:(NSString *)CouponId IsCoupon:(NSString *)IsCoupon AddId:(NSString *)AddId Remark:(NSString *)Remark OrderType:(NSString *)OrderType PresetTime:(NSString *)PresetTime OrderList:(NSArray *)OrderList success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:X_CLIENT_TOKEN];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Order/SubmitOrder"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:OrderList
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:UserId,@"UserId" ,CompanyId,@"CompanyId",Type,@"Type",CouponId,@"CouponId",IsCoupon,@"IsCoupon",AddId,@"AddId",Remark,@"Remark",OrderType,@"OrderType",PresetTime,@"PresetTime",jsonStr,@"OrderList",nil];
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];

}

-(void)PayDes:(NSString *)Order Type:(NSString*)Type success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:X_CLIENT_TOKEN];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Payment/PayDes?Order=%@&Type=%@",Order,Type];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)OrderList:(NSString *)Type success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/UserOrder/OrderList?Type=%@",Type];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:X_CLIENT_TOKEN];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)WxPayDes:(NSString *)Order success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:X_CLIENT_TOKEN];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/WxPayment/WxPayDes?Order=%@",Order];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)StoresList:(NSString *)lat lon:(NSString *)lon success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:X_CLIENT_TOKEN];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Product/StoresList?lat=%@&lon=%@",lat,lon];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

-(void)ConfirmOrder:(NSString *)OrderId Type:(NSString *)Type success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:X_CLIENT_TOKEN];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/UserOrder/ConfirmOrder?OrderId=%@&Type=%@",OrderId,Type];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}


@end
