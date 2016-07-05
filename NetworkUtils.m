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
    NSString *url = [SeviceURL stringByAppendingFormat:@"/ProClass/ListProClass"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}
-(void)ClassProductList:(NSString *)compnayId classId:(NSString *)classId success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/ProClass/ClassProductList?CompnayId=%@&ClassId=%@",compnayId,classId];
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
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Product/ProDetail?FGuId=%@&ActType=%@&IsAct=%@",FGuId,ActType,IsAct];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}
-(void)userAddressList:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:X_CLIENT_TOKEN];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Addlist/UserAddList"];
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
    NSString *url = [SeviceURL stringByAppendingFormat:@"/Activitys/ActivityList?ActivityId=%@&ActType=%@",ActivityId,ActType];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}



@end
