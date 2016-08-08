//
//  AppUtils
//
//
//  Created by somilk
//  Copyright (c) 2012年 somilk. All rights reserved.
//


#import "AppUtils.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "WXMediaMessage+messageConstruct.h"
#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"

//#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"
@implementation AppUtils
static NSString * const FORM_FLE_INPUT = @"fileupload";


#pragma mark 得到服务器端地址[1]
#pragma mark 调用电话phone[3]
+ (void) callPhone:(NSString *)number
{
    NSString * temp = [@"telprompt://" stringByAppendingString:number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:temp]];
    static dispatch_once_t onceToken;
   
}
//#pragma mark 检测网络
//+(BOOL)checkNetWorkingState{
//    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:
//            // 没有网络连接
//            return NO;
//            break;
//        case ReachableViaWWAN:
//            // 使用3G网络
//            return YES;
//            break;
//        case ReachableViaWiFi:
//            // 使用WiFi网络
//            return YES;
//            break;
//    }
//    
//}
#pragma mark 手机号验证[8]
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((14[5,7])|(13[0-9])|(15[0-9])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
#pragma mark 提示框[9]
+ (void) showAlertView:(NSString *)Titile STR:(NSString*)str BtnTxt:(NSString *)btntxt{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:Titile
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:btntxt
                                          otherButtonTitles:nil];
    [alert show];
}
+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN 提交参数据集合
                        picImage: (UIImage *)picImage  // IN 上传图片
                     picFileName: (NSString *)picFileName{
    
//        //截取图片
    NSData *imageData = UIImageJPEGRepresentation(picImage, 0.001);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:X_CLIENT_TOKEN];

    [manager POST:url parameters:postParems constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传文件
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat            = @"yyyyMMddHHmmss";
        NSString *str                         = [formatter stringFromDate:[NSDate date]];
        NSString *fileName               = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"photos" fileName:fileName mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"上传成功");

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"上传失败");

     }];
    return nil;
}

/**
 * 修发图片大小
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
    
}

/**
 * 保存图片
 */
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSData* imageData;
    
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(tempImage)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(tempImage);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSArray *nameAry=[fullPathToFile componentsSeparatedByString:@"/"];
    NSLog(@"===fullPathToFile===%@",fullPathToFile);
    NSLog(@"===FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}

/**
 * 生成GUID
 */
+ (NSString *)generateUuidString{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // transfer ownership of the string
    // to the autorelease pool
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}
#pragma mark 图片裁减[7]
+ (UIImage*) callOriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
#pragma mark 分享链接
+ (BOOL)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene {
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:thumbImage
                                                      MediaTag:tagName];
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

//设置圆角
+(id) setViewRand:(UIView *) viewT andRadius:(CGFloat) Fradius andViewBorder:(CGFloat) Fborder andColor:(UIColor *) Lcolor{
    viewT.layer.cornerRadius = Fradius;//设置那个圆角的有多圆
    viewT.layer.borderWidth = Fborder;//设置边框的宽度，当然可以不要
    viewT.layer.borderColor =[Lcolor CGColor];//设置边框的颜色
    viewT.layer.masksToBounds = NO;//设为NO去试试
    //    viewT.layer.shadowColor = [UIColor redColor].CGColor;//shadowColor阴影颜色
    //    viewT.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    //    viewT.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    //    viewT.layer.shadowRadius = 4;//阴影半径，默认3
    return viewT;
    
}
#pragma mark   检查是否为空

+(BOOL)checkNullValue:(id)sender{
    
    if (sender==nil||sender==[NSNull null]) {
        return YES;
    }
    return  NO;
}
#pragma mark HTML码转换UIcolor
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [self colorWithFloatRed:r green:g blue:b];
}
+ (UIColor *)colorWithFloatRed:(float)r green:(float)g blue:(float)b
{
    return [UIColor colorWithRed:(r / 255.0f)
                           green:(g / 255.0f)
                            blue:(b / 255.0f)
                           alpha:1.0f];
}

//#pragma mark 根据图片url获取图片尺寸
//+(CGSize)getImageSizeWithURL:(id)imageURL
//{
//    NSURL* URL = nil;
//    if([imageURL isKindOfClass:[NSURL class]]){
//        URL = imageURL;
//    }
//    if([imageURL isKindOfClass:[NSString class]]){
//        URL = [NSURL URLWithString:imageURL];
//    }
//    if(URL == nil)
//        return CGSizeZero;                  // url不正确返回CGSizeZero
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
//    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
//    
//    CGSize size = CGSizeZero;
//    if([pathExtendsion isEqualToString:@"png"]){
//        size =  [self getPNGImageSizeWithRequest:request];
//    }
//    else if([pathExtendsion isEqual:@"gif"])
//    {
//        size =  [self getGIFImageSizeWithRequest:request];
//    }
//    else{
//        size =  [self getJPGImageSizeWithRequest:request];
//    }
//    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
//    {
//        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
//        UIImage* image = [UIImage imageWithData:data];
//        if(image)
//        {
//            size = image.size;
//        }
//    }
//    return size;
//}
////  获取PNG图片的大小
//+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
//{
//    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if(data.length == 8)
//    {
//        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
//        [data getBytes:&w1 range:NSMakeRange(0, 1)];
//        [data getBytes:&w2 range:NSMakeRange(1, 1)];
//        [data getBytes:&w3 range:NSMakeRange(2, 1)];
//        [data getBytes:&w4 range:NSMakeRange(3, 1)];
//        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
//        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
//        [data getBytes:&h1 range:NSMakeRange(4, 1)];
//        [data getBytes:&h2 range:NSMakeRange(5, 1)];
//        [data getBytes:&h3 range:NSMakeRange(6, 1)];
//        [data getBytes:&h4 range:NSMakeRange(7, 1)];
//        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
//        return CGSizeMake(w, h);
//    }
//    return CGSizeZero;
//}
////  获取gif图片的大小
//+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
//{
//    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if(data.length == 4)
//    {
//        short w1 = 0, w2 = 0;
//        [data getBytes:&w1 range:NSMakeRange(0, 1)];
//        [data getBytes:&w2 range:NSMakeRange(1, 1)];
//        short w = w1 + (w2 << 8);
//        short h1 = 0, h2 = 0;
//        [data getBytes:&h1 range:NSMakeRange(2, 1)];
//        [data getBytes:&h2 range:NSMakeRange(3, 1)];
//        short h = h1 + (h2 << 8);
//        return CGSizeMake(w, h);
//    }
//    return CGSizeZero;
//}
////  获取jpg图片的大小
//+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
//{
//    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    
//    if ([data length] <= 0x58) {
//        return CGSizeZero;
//    }
//    
//    if ([data length] < 210) {// 肯定只有一个DQT字段
//        short w1 = 0, w2 = 0;
//        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
//        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
//        short w = (w1 << 8) + w2;
//        short h1 = 0, h2 = 0;
//        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
//        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
//        short h = (h1 << 8) + h2;
//        return CGSizeMake(w, h);
//    } else {
//        short word = 0x0;
//        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
//        if (word == 0xdb) {
//            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
//            if (word == 0xdb) {// 两个DQT字段
//                short w1 = 0, w2 = 0;
//                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
//                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
//                short w = (w1 << 8) + w2;
//                short h1 = 0, h2 = 0;
//                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
//                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
//                short h = (h1 << 8) + h2;
//                return CGSizeMake(w, h);
//            } else {// 一个DQT字段
//                short w1 = 0, w2 = 0;
//                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
//                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
//                short w = (w1 << 8) + w2;
//                short h1 = 0, h2 = 0;
//                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
//                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
//                short h = (h1 << 8) + h2;
//                return CGSizeMake(w, h);
//            }
//        } else {
//            return CGSizeZero;
//        }
//    }  }

+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end

