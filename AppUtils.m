//
//  AppUtils
//
//
//  Created by somilk
//  Copyright (c) 2012年 somilk. All rights reserved.
//


#import "AppUtils.h"
#import "AppDelegate.h"
#import <Reachability.h>
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
#pragma mark 检测网络
+(BOOL)checkNetWorkingState{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            return NO;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            return YES;
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            return YES;
            break;
    }
    
}
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
                      postParems: (NSMutableDictionary *)postParems // IN
                     picFilePath: (NSString *)picFilePath  // IN
                     picFileName: (NSString *)picFileName;  // IN
{
    
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    if(picFilePath){
        
        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        return result;
    }
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
//#pragma mark 分享链接
//+ (BOOL)sendLinkURL:(NSString *)urlString
//            TagName:(NSString *)tagName
//              Title:(NSString *)title
//        Description:(NSString *)description
//         ThumbImage:(UIImage *)thumbImage
//            InScene:(enum WXScene)scene {
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = urlString;
//    
//    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
//                                                   Description:description
//                                                        Object:ext
//                                                    MessageExt:nil
//                                                 MessageAction:nil
//                                                    ThumbImage:thumbImage
//                                                      MediaTag:tagName];
//    
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:scene];
//    return [WXApi sendReq:req];
//}

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
@end

