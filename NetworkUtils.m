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
-(void)companyDetail:(NSString *)lat lon:(NSString *)lon success:(SuccessBlock)success failure:(FailureBlock)faileure{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    NSString *url = [SeviceURL stringByAppendingFormat:@"/CompanyDetail/Company?lat=%@&lon=%@",lat,lon];
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
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:compnayId,@"CompnayId",Order,@"Order",serchStr,@"str", nil];
    NSLog(@"%@",url);
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        faileure(errorStr);
    }];
}

@end
