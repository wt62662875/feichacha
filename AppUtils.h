//
//  AppUtils
//  
//
//  Created by somilk
//  Copyright (c) 2014年 somilk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <Reachability.h>

@interface AppUtils : NSObject
+ (void) callPhone:(NSString *)number;
+ (BOOL)checkNetWorkingState;//判断连接
+ (void) showAlertView:(NSString *)Titile STR:(NSString*)str BtnTxt:(NSString *)btntxt;//提示框
+ (BOOL)isValidateMobile:(NSString *)mobile;//手机号
/**
 *POST 提交 并可以上传图片目前只支持单张
 */
+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN 提交参数据集合
                     picFilePath: (NSString *)picFilePath  // IN 上传图片路径
                     picFileName: (NSString *)picFileName;  // IN 上传图片名称
+ (UIImage*) callOriginImage:(UIImage *)image scaleToSize:(CGSize)size;

/**
 * 修发图片大小
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;
/**
 * 保存图片
 */
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
/**
 * 生成GUID
 */
+ (NSString *)generateUuidString;
#pragma mark 分享链接
//+ (BOOL)sendLinkURL:(NSString *)urlString
//            TagName:(NSString *)tagName
//              Title:(NSString *)title
//        Description:(NSString *)description
//         ThumbImage:(UIImage *)thumbImage
//            InScene:(enum WXScene)scene;

/**
 * 设置圆角
 */
+(id) setViewRand:(UIView *) viewT andRadius:(CGFloat) Fradius andViewBorder:(CGFloat) Fborder andColor:(UIColor *) Lcolor;


/**
 * 检查是否为空
 */
+(BOOL)checkNullValue:(id)sender;

#pragma mark HTML码转换UIcolor
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
#pragma mark 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;
@end



